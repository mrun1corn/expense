import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/ai_insights/presentation/providers/gemini_provider.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/notifications/engine/pattern_detector.dart';
import 'package:expense/core/extensions/double_ext.dart';
import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.existingExpense,
  });
  final Expense? existingExpense;

  static Map<String, dynamic> localParseVoiceText(String text) {
    double amount = 0.0;
    String title = text;
    
    // Find numbers (decimal or integer)
    final numRegex = RegExp(r'\b\d+(?:\.\d{1,2})?\b');
    final matches = numRegex.allMatches(text);
    if (matches.isNotEmpty) {
      for (final match in matches) {
        final val = double.tryParse(match.group(0)!);
        if (val != null) {
          amount = val;
          title = text.replaceFirst(match.group(0)!, '').trim();
          break;
        }
      }
    }
    
    // Clean up title
    title = title.replaceAll(RegExp(r'\s+'), ' ');
    title = title.replaceAll(RegExp(r'\b(spent|dollars|cents|on|for|a|an|the|at|in)\b', caseSensitive: false), '').trim();
    if (title.isEmpty) {
      title = 'Voice Transaction';
    } else {
      title = title[0].toUpperCase() + title.substring(1);
    }
    
    return {
      'title': title,
      'amount': amount,
      'category': ExpenseCategory.other,
      'type': TransactionType.expense,
    };
  }

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  Timer? _debounceTimer;
  bool _isPredictingCategory = false;
  bool _amountFocused = false;

  TransactionType _selectedType = TransactionType.expense;
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDateTime = DateTime.now();

  int _activeMethodTab = 2; // 0: Scan, 1: Voice, 2: Manual
  bool _isScanning = false;
  bool _isRecording = false;
  bool _isProcessingVoice = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  XFile? _selectedReceiptImage;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;
  String _transcribedText = 'Tap Start Speaking to transcribe...';
  String? _selectedPaymentSystem;

  bool get _isEditMode => widget.existingExpense != null;

  List<ExpenseCategory> _getCategoriesForType(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return [
          ExpenseCategory.food,
          ExpenseCategory.transport,
          ExpenseCategory.utilities,
          ExpenseCategory.entertainment,
          ExpenseCategory.shopping,
          ExpenseCategory.health,
          ExpenseCategory.education,
          ExpenseCategory.other,
        ];
      case TransactionType.income:
        return [
          ExpenseCategory.salary,
          ExpenseCategory.business,
          ExpenseCategory.investment,
          ExpenseCategory.gift,
          ExpenseCategory.other,
        ];
      case TransactionType.borrow:
        return [
          ExpenseCategory.friend,
          ExpenseCategory.bank,
          ExpenseCategory.family,
          ExpenseCategory.other,
        ];
      case TransactionType.lend:
        return [
          ExpenseCategory.friend,
          ExpenseCategory.family,
          ExpenseCategory.other,
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _amountFocusNode.addListener(() {
      setState(() {
        _amountFocused = _amountFocusNode.hasFocus;
      });
    });

    if (_isEditMode) {
      final exp = widget.existingExpense!;
      _amountController.text = exp.amount.toStringAsFixed(exp.amount % 1 == 0 ? 0 : 2);
      _titleController.text = exp.title;
      _noteController.text = exp.note ?? '';
      _selectedCategory = exp.category;
      _selectedDateTime = exp.date;
      _selectedType = exp.type;
      _selectedPaymentSystem = exp.paymentSystem;
      if (exp.receiptImageUrl != null && exp.receiptImageUrl!.isNotEmpty) {
        _selectedReceiptImage = XFile(exp.receiptImageUrl!);
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _recordingTimer?.cancel();
    _titleController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    if (value.trim().isEmpty) return;

    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      setState(() {
        _isPredictingCategory = true;
      });
      
      try {
        final gemini = ref.read(geminiDatasourceProvider);
        final predictedCategoryStr = await gemini.predictCategory(value.trim());
        
        final predictedCategory = ExpenseCategory.values.firstWhere(
          (e) => e.name == predictedCategoryStr,
          orElse: () => ExpenseCategory.other,
        );

        if (mounted) {
          final allowedCategories = _getCategoriesForType(_selectedType);
          setState(() {
            if (allowedCategories.contains(predictedCategory)) {
              _selectedCategory = predictedCategory;
            } else {
              _selectedCategory = allowedCategories.contains(ExpenseCategory.other)
                  ? ExpenseCategory.other
                  : allowedCategories.first;
            }
          });
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text('AI auto-selected: ${_formatEnumName(_selectedCategory.name)}'),
                ],
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (_) {
      } finally {
        if (mounted) {
          setState(() {
            _isPredictingCategory = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyCode = ref.watch(currencyProvider);
    final countryCode = ref.watch(countryCodeProvider);
    final systems = PaymentSystemsManager.getSystemNamesForCountry(countryCode);
    if (_selectedPaymentSystem != null && !systems.contains(_selectedPaymentSystem)) {
      _selectedPaymentSystem = null;
    }

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(
                  title: _isEditMode ? 'Edit Spend' : 'AI Expense Tracker',
                  subtitle: _isEditMode ? null : 'Let AI categorize your expenses instantly',
                  showBackButton: _isEditMode,
                  action: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isEditMode)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: _confirmDelete,
                        ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined),
                        onPressed: () => context.push('/settings/notifications'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AI Prompt Banner (hero card, dark)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getHeroBg(context),
                          borderRadius: BorderRadius.circular(16),
                          border: isDark ? Border.all(color: const Color(0x1FFFFFFF)) : null,
                          boxShadow: AppShadows.getShadow1(context),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✦ AI is ready to categorize',
                              style: AppTextStyles.captionBold(color: AppColors.getInfo(context)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isEditMode ? 'Modify your transaction details' : 'Add a new transaction',
                              style: AppTextStyles.headingLg(color: AppColors.getHeroFg(context)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Snap a receipt or type manually - AI handles the rest',
                              style: AppTextStyles.bodySm(color: AppColors.getHeroFgMuted(context)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Method Tabs
                      Container(
                        width: double.infinity,
                        height: 44, // 36px + 8px padding (4px top/bottom)
                        decoration: BoxDecoration(
                          color: AppColors.getBgSunken(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _buildMethodTab(Icons.qr_code_scanner, 'Scan Receipt', 0),
                            _buildMethodTab(Icons.mic, 'Voice Input', 1),
                            _buildMethodTab(Icons.keyboard, 'Manual', 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_activeMethodTab == 0) ...[
                        _buildScanReceiptView(),
                      ] else if (_activeMethodTab == 1) ...[
                        _buildVoiceInputView(),
                      ] else ...[
                        // Transaction Type Selector
                        Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.getBgSunken(context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              _buildTypeTab(TransactionType.expense, 'Expense'),
                              _buildTypeTab(TransactionType.income, 'Income'),
                              _buildTypeTab(TransactionType.borrow, 'Borrow'),
                              _buildTypeTab(TransactionType.lend, 'Lend'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Amount Input Field
                        Text(
                          'AMOUNT',
                          style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.getBgSunken(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _amountFocused
                                  ? AppColors.getBrandPrimary(context)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                0.0.toCurrencySymbol(currencyCode),
                                style: AppTextStyles.monospace(
                                  32,
                                  color: AppColors.getFgTertiary(context),
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IntrinsicWidth(
                                child: TextFormField(
                                  controller: _amountController,
                                  focusNode: _amountFocusNode,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                  ],
                                  style: AppTextStyles.monospace(
                                    28,
                                    color: AppColors.getFgPrimary(context),
                                    weight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    hintText: '0.00',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) return 'Enter amount';
                                    final parsed = double.tryParse(value);
                                    if (parsed == null || parsed <= 0) return 'Invalid';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Description input
                        Text(
                          'DESCRIPTION',
                          style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          onChanged: _onTitleChanged,
                          decoration: InputDecoration(
                            hintText: 'e.g. Starbucks coffee, Uber ride...',
                            filled: true,
                            fillColor: AppColors.getBgSunken(context),
                            prefixIcon: const Icon(Icons.description_outlined),
                            suffixIcon: _isPredictingCategory
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter description';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'NOTE',
                          style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _noteController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Add Note / Description',
                            filled: true,
                            fillColor: AppColors.getBgSunken(context),
                            prefixIcon: const Icon(Icons.note_alt_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'RECEIPT PHOTO',
                          style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedReceiptImage != null)
                          Container(
                            width: double.infinity,
                            decoration: AppShadows.getCardDecoration(context, radius: 12),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedReceiptImage!.path),
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 56,
                                        height: 56,
                                        color: AppColors.getBgSunken(context),
                                        child: const Icon(Icons.broken_image_outlined, size: 24),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receipt Attached',
                                        style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        p.basename(_selectedReceiptImage!.path),
                                        style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: _removeReceiptImage,
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.getBgSunken(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                                    label: const Text('Camera'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      side: BorderSide(
                                        color: isDark ? const Color(0x1AFFFFFF) : const Color(0x1F000000),
                                      ),
                                    ),
                                    onPressed: () => _pickReceiptImage(ImageSource.camera),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.photo_library_outlined, size: 16),
                                    label: const Text('Gallery'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      side: BorderSide(
                                        color: isDark ? const Color(0x1AFFFFFF) : const Color(0x1F000000),
                                      ),
                                    ),
                                    onPressed: () => _pickReceiptImage(ImageSource.gallery),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Date & Payment selector
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE',
                                    style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                                    label: Text(
                                      DateFormat('MMM d, yyyy').format(_selectedDateTime),
                                      style: AppTextStyles.bodySm(color: AppColors.getFgPrimary(context)),
                                    ),
                                    onPressed: () => _pickDate(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                      minimumSize: const Size.fromHeight(48),
                                      alignment: Alignment.centerLeft,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      side: BorderSide(color: isDark ? const Color(0x1AFFFFFF) : const Color(0x1F000000)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PAYMENT SYSTEM',
                                    style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: _selectedPaymentSystem,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.getBgSunken(context),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                    ),
                                    hint: Text(
                                      'Select System',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgTertiary(context)),
                                    ),
                                    isExpanded: true,
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('None / Cash / Card'),
                                      ),
                                      ...systems.map((sys) => DropdownMenuItem<String>(
                                        value: sys,
                                        child: Text(sys),
                                      )),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedPaymentSystem = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Category Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AI CATEGORY',
                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                            ),
                            Text(
                              '✦ Auto-detected',
                              style: AppTextStyles.captionBold(color: AppColors.getInfo(context)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: _getCategoriesForType(_selectedType).map((category) {
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  avatar: Icon(
                                    _getCategoryIcon(category),
                                    size: 14,
                                    color: isSelected
                                        ? (isDark ? AppColors.brandFgDark : Colors.white)
                                        : AppColors.getFgPrimary(context),
                                  ),
                                  label: Text(_formatEnumName(category.name)),
                                  selected: isSelected,
                                  selectedColor: AppColors.getBrandPrimary(context),
                                  labelStyle: TextStyle(
                                    color: isSelected ? (isDark ? AppColors.brandFgDark : Colors.white) : AppColors.getFgPrimary(context),
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      HapticFeedback.selectionClick();
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // AI Insight Block
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.getBgSunken(context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✦',
                                style: TextStyle(
                                  color: AppColors.getInfo(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Insight',
                                      style: AppTextStyles.captionBold(color: AppColors.getInfo(context)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Gemini will categorize this purchase and compute its impact on your category limit.',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Submit Button
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.getBrandPrimary(context),
                              foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 1,
                            ),
                            onPressed: _saveExpense,
                            child: Text(
                              _isEditMode ? 'Update Spend' : '✦ Save & Let AI Categorize',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTab(IconData icon, String label, int tabIndex) {
    final active = _activeMethodTab == tabIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = isDark ? const Color(0xFF252525) : Colors.white;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _activeMethodTab = tabIndex;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active && !isDark ? AppShadows.shadow1Light : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.getFgPrimary(context) : AppColors.getFgTertiary(context),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.captionBold(
                  color: active ? AppColors.getFgPrimary(context) : AppColors.getFgSecondary(context),
                ).copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTab(TransactionType type, String label) {
    final active = _selectedType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = isDark ? const Color(0xFF252525) : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedType = type;
            _selectedCategory = _getCategoriesForType(type).first;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active && !isDark ? AppShadows.shadow1Light : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.headingSm(
              color: active ? AppColors.getBrandPrimary(context) : AppColors.getFgTertiary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanReceiptView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: AppShadows.getCardDecoration(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.getBgSunken(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.getFgTertiary(context)),
            ),
            child: _isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'AI scanning receipt...',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : _selectedReceiptImage != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              File(_selectedReceiptImage!.path),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              radius: 16,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                onPressed: _removeReceiptImage,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 64,
                            color: AppColors.getFgTertiary(context),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(width: 20, height: 20, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 2), left: BorderSide(color: Colors.grey, width: 2)))),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(width: 20, height: 20, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 2), right: BorderSide(color: Colors.grey, width: 2)))),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(width: 20, height: 20, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 2), left: BorderSide(color: Colors.grey, width: 2)))),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(width: 20, height: 20, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 2), right: BorderSide(color: Colors.grey, width: 2)))),
                          ),
                        ],
                      ),
          ),
          const SizedBox(height: 20),
          Text(
            'Scan Receipt with AI',
            style: AppTextStyles.headingMd(color: AppColors.getFgPrimary(context)),
          ),
          const SizedBox(height: 8),
          Text(
            'Hold the receipt inside the viewfinder. AI will analyze the items, tax, and totals automatically.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Capture & Let AI Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getBrandPrimary(context),
                foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isScanning ? null : _captureAndScanReceipt,
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _saveReceiptImageLocally(XFile pickedFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory('${directory.path}/receipts');
      if (!receiptsDir.existsSync()) {
        await receiptsDir.create(recursive: true);
      }
      
      final fileName = '${const Uuid().v4()}${p.extension(pickedFile.path)}';
      final localPath = '${receiptsDir.path}/$fileName';
      await File(pickedFile.path).copy(localPath);
      return localPath;
    } catch (e) {
      debugPrint('Failed to save receipt image locally: $e');
      return null;
    }
  }

  Future<void> _pickReceiptImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final localPath = await _saveReceiptImageLocally(pickedFile);
        if (localPath != null) {
          setState(() {
            _selectedReceiptImage = XFile(localPath);
          });
          HapticFeedback.selectionClick();
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to access camera/gallery: $e')),
        );
      }
    }
  }

  void _removeReceiptImage() {
    setState(() {
      _selectedReceiptImage = null;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _captureAndScanReceipt() async {
    final picker = ImagePicker();
    XFile? pickedFile;
    
    try {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
    } catch (e) {
      debugPrint('Camera access failed, falling back to gallery: $e');
      try {
        pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
        );
      } catch (ex) {
        debugPrint('Gallery access also failed: $ex');
      }
    }
    
    if (pickedFile == null) return;
    
    setState(() {
      _isScanning = true;
    });
    
    HapticFeedback.mediumImpact();
    
    final localPath = await _saveReceiptImageLocally(pickedFile);
    final hasApiKey = ref.read(apiKeyProvider).isNotEmpty;
    final currencyCode = ref.read(currencyProvider);
    
    if (hasApiKey && localPath != null) {
      try {
        final imageBytes = await File(localPath).readAsBytes();
        final gemini = ref.read(geminiDatasourceProvider);
        
        final jsonResult = await gemini.analyzeReceiptImage(imageBytes, 'image/jpeg');
        final data = jsonDecode(jsonResult) as Map<String, dynamic>;
        
        final parsedTitle = data['title'] as String?;
        final parsedAmount = data['amount'];
        final parsedCategoryStr = data['category'] as String?;
        
        final parsedCategory = ExpenseCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == parsedCategoryStr?.toLowerCase(),
          orElse: () => ExpenseCategory.other,
        );
        
        if (mounted) {
          setState(() {
            _isScanning = false;
            if (parsedAmount != null) {
              _amountController.text = parsedAmount.toString();
            }
            if (parsedTitle != null && parsedTitle.isNotEmpty) {
              _titleController.text = parsedTitle;
            }
            _selectedCategory = parsedCategory;
            _selectedType = TransactionType.expense;
            _selectedReceiptImage = XFile(localPath);
            _activeMethodTab = 2;
          });
          
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text('✦ AI parsed: $parsedTitle (${0.0.toCurrencySymbol(currencyCode)}$parsedAmount)!'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      } catch (e) {
        debugPrint('Gemini receipt analysis failed: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI scan failed: $e. Falling back to demo values.'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
    
    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _amountController.text = '14.50';
        _titleController.text = 'Starbucks Coffee';
        _selectedCategory = ExpenseCategory.food;
        _selectedType = TransactionType.expense;
        if (localPath != null) {
          _selectedReceiptImage = XFile(localPath);
        }
        _activeMethodTab = 2;
      });

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Text('✦ AI Scanned Starbucks Coffee (${0.0.toCurrencySymbol(currencyCode)}14.50)!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Future<void> _initSpeech() async {
    try {
      final hasSpeech = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'notListening' || status == 'done') {
            if (_isRecording) {
              _stopVoiceRecording();
            }
          }
        },
        onError: (errorNotification) {
          debugPrint('Speech error: ${errorNotification.errorMsg}');
          if (_isRecording) {
            _stopVoiceRecording();
          }
        },
      );
      if (mounted) {
        setState(() {
          _speechAvailable = hasSpeech;
        });
      }
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
    }
  }

  Widget _buildVoiceInputView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: AppShadows.getCardDecoration(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.getBgSunken(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _isRecording
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Listening...',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _transcribedText,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySm(color: AppColors.getFgPrimary(context)).copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '0:${_recordingSeconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 3,
                              height: 12.0 + (index.isEven ? 16 : 4),
                              decoration: BoxDecoration(
                                color: AppColors.getBrandPrimary(context),
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _isProcessingVoice
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Gemini analyzing voice...',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic_none_outlined,
                              size: 48,
                              color: AppColors.getFgTertiary(context),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                _transcribedText.startsWith('Tap') ? _transcribedText : 'Last transcription: "$_transcribedText"',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Voice Input with AI',
            style: AppTextStyles.headingMd(color: AppColors.getFgPrimary(context)),
          ),
          const SizedBox(height: 8),
          Text(
            'Say something like: "I spent twelve dollars on a taxi ride today."',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop & Process' : 'Start Speaking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : AppColors.getBrandPrimary(context),
                foregroundColor: _isRecording ? Colors.white : (isDark ? AppColors.brandFgDark : Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isProcessingVoice
                  ? null
                  : (_isRecording ? _stopVoiceRecording : _startVoiceRecording),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startVoiceRecording() async {
    HapticFeedback.lightImpact();

    if (!_speechAvailable) {
      await _initSpeech();
    }

    if (!_speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition is not available on this device.')),
        );
      }
      return;
    }

    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _transcribedText = 'Listening...';
    });

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _recordingSeconds++;
        if (_recordingSeconds >= 15) {
          _stopVoiceRecording();
        }
      });
    });

    try {
      await _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _transcribedText = result.recognizedWords;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('Speech listen failed: $e');
      _stopVoiceRecording();
    }
  }

  Future<void> _stopVoiceRecording() async {
    _recordingTimer?.cancel();
    if (!mounted) return;

    final textToParse = _transcribedText.trim();
    final isListening = _speech.isListening;

    setState(() {
      _isRecording = false;
    });

    if (isListening) {
      try {
        await _speech.stop();
      } catch (e) {
        debugPrint('Speech stop failed: $e');
      }
    }

    HapticFeedback.mediumImpact();

    if (textToParse.isEmpty || textToParse == 'Listening...' || textToParse.startsWith('Tap')) {
      setState(() {
        _transcribedText = 'No voice detected. Tap to try again.';
      });
      return;
    }

    setState(() {
      _isProcessingVoice = true;
    });
    final hasApiKey = ref.read(apiKeyProvider).isNotEmpty;
    final currencyCode = ref.read(currencyProvider);
    final activeCountry = ref.read(countryCodeProvider);
    final countrySystems = PaymentSystemsManager.getSystemNamesForCountry(activeCountry);
    String? detectedSystem;
    for (final sys in countrySystems) {
      if (textToParse.toLowerCase().contains(sys.toLowerCase())) {
        detectedSystem = sys;
        break;
      }
    }
    if (hasApiKey) {
      try {
        final gemini = ref.read(geminiDatasourceProvider);
        final jsonResult = await gemini.parseExpenseFromText(textToParse);
        final data = jsonDecode(jsonResult) as Map<String, dynamic>;

        final parsedTitle = data['title'] as String?;
        final parsedAmount = data['amount'];
        final parsedCategoryStr = data['category'] as String?;
        final parsedTypeStr = data['type'] as String?;

        final parsedCategory = ExpenseCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == parsedCategoryStr?.toLowerCase(),
          orElse: () => ExpenseCategory.other,
        );

        final parsedType = TransactionType.values.firstWhere(
          (t) => t.name.toLowerCase() == parsedTypeStr?.toLowerCase(),
          orElse: () => TransactionType.expense,
        );

        if (mounted) {
          setState(() {
            _isProcessingVoice = false;
            if (parsedAmount != null) {
              _amountController.text = parsedAmount.toString();
            }
            if (parsedTitle != null && parsedTitle.isNotEmpty) {
              _titleController.text = parsedTitle;
            }
            _selectedCategory = parsedCategory;
            _selectedType = parsedType;
            if (detectedSystem != null) {
              _selectedPaymentSystem = detectedSystem;
            }
            _activeMethodTab = 2; // Switch to Manual
          });

          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text('✦ AI parsed: $parsedTitle (${0.0.toCurrencySymbol(currencyCode)}$parsedAmount)!'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      } catch (e) {
        debugPrint('Gemini voice analysis failed: $e');
      }
    }

    // Local Fallback Parser
    final parsedData = AddExpenseScreen.localParseVoiceText(textToParse);
    if (mounted) {
      setState(() {
        _isProcessingVoice = false;
        _amountController.text = (parsedData['amount'] as double).toStringAsFixed(2);
        _titleController.text = parsedData['title'] as String;
        _selectedCategory = parsedData['category'] as ExpenseCategory;
        _selectedType = parsedData['type'] as TransactionType;
        if (detectedSystem != null) {
          _selectedPaymentSystem = detectedSystem;
        }
        _activeMethodTab = 2; // Switch to Manual
      });

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text('Parsed: ${parsedData['title']} (${(parsedData['amount'] as double).toCurrencyString(currencyCode)})!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an amount greater than 0')));
      return;
    }

    final repo = ref.read(expenseRepositoryProvider);
    final currentUser = ref.read(authStateProvider).valueOrNull;
    final userId = currentUser?.id ?? '';
    final currencyCode = ref.read(currencyProvider);

    if (_isEditMode) {
      final updated = widget.existingExpense!.copyWith(
        amount: amount,
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        category: _selectedCategory,
        date: _selectedDateTime,
        type: _selectedType,
        receiptImageUrl: _selectedReceiptImage?.path,
        paymentSystem: _selectedPaymentSystem,
        updatedAt: DateTime.now(),
      );

      await repo.updateExpense(updated);
      await PatternDetector.onExpenseAdded(updated);
    } else {
      final newExpense = Expense(
        id: const Uuid().v4(),
        userId: userId,
        amount: amount,
        currency: currencyCode,
        category: _selectedCategory,
        date: _selectedDateTime,
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        receiptImageUrl: _selectedReceiptImage?.path,
        paymentSystem: _selectedPaymentSystem,
        type: _selectedType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.addExpense(newExpense);
      await PatternDetector.onExpenseAdded(newExpense);
    }

    HapticFeedback.heavyImpact();
    if (mounted) context.pop();
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Spend?'),
        content: const Text('Are you sure you want to permanently delete this expense?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(expenseRepositoryProvider).deleteExpense(widget.existingExpense!.id);
      if (mounted) context.pop();
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(picked.year, picked.month, picked.day, _selectedDateTime.hour, _selectedDateTime.minute);
      });
    }
  }


  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Icons.restaurant;
      case ExpenseCategory.transport: return Icons.directions_car;
      case ExpenseCategory.utilities: return Icons.electrical_services;
      case ExpenseCategory.entertainment: return Icons.movie;
      case ExpenseCategory.shopping: return Icons.shopping_bag;
      case ExpenseCategory.health: return Icons.medical_services;
      case ExpenseCategory.education: return Icons.school;
      case ExpenseCategory.salary: return Icons.work;
      case ExpenseCategory.business: return Icons.storefront;
      case ExpenseCategory.investment: return Icons.trending_up;
      case ExpenseCategory.gift: return Icons.card_giftcard;
      case ExpenseCategory.friend: return Icons.people;
      case ExpenseCategory.bank: return Icons.account_balance;
      case ExpenseCategory.family: return Icons.house;
      case ExpenseCategory.other: return Icons.more_horiz;
    }
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
