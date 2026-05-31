import 'dart:async';

import 'package:expense/features/ai_insights/presentation/providers/gemini_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/notifications/engine/pattern_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {

  const AddExpenseScreen({
    super.key,
    this.existingExpense,
  });
  final Expense? existingExpense;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  Timer? _debounceTimer;
  bool _isPredictingCategory = false;

  String _amountString = '0';
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDateTime = DateTime.now();
  String? _receiptImagePath;

  bool get _isEditMode => widget.existingExpense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final exp = widget.existingExpense!;
      _amountString = exp.amount.toStringAsFixed(exp.amount % 1 == 0 ? 0 : 2);
      _titleController.text = exp.title;
      _noteController.text = exp.note ?? '';
      _selectedCategory = exp.category;
      _selectedDateTime = exp.date;
      _receiptImagePath = exp.receiptImageUrl;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _noteController.dispose();
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
          setState(() {
            _selectedCategory = predictedCategory;
          });
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI auto-selected: ${_formatEnumName(predictedCategory.name)}'),
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

  void _onKeypadTap(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (value == '⌫') {
        if (_amountString.length > 1) {
          _amountString = _amountString.substring(0, _amountString.length - 1);
        } else {
          _amountString = '0';
        }
      } else if (value == '.') {
        if (!_amountString.contains('.')) {
          _amountString += '.';
        }
      } else {
        if (_amountString == '0') {
          _amountString = value;
        } else {
          if (_amountString.contains('.')) {
            final decimals = _amountString.split('.')[1];
            if (decimals.length < 2) {
              _amountString += value;
            }
          } else {
            _amountString += value;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountString) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Spend' : 'Add Spend'),
        actions: _isEditMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _confirmDelete,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AMOUNT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        r'💵$amount',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          onChanged: _onTitleChanged,
                          decoration: InputDecoration(
                            labelText: 'What did you buy? *',
                            prefixIcon: const Icon(Icons.description),
                            suffixIcon: _isPredictingCategory 
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16, height: 16, 
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ) 
                                : null,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Please enter a title';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.calendar_month),
                                label: Text(DateFormat('MMM d, yyyy').format(_selectedDateTime)),
                                onPressed: () => _pickDate(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.access_time),
                                label: Text(DateFormat('h:mm a').format(_selectedDateTime)),
                                onPressed: () => _pickTime(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: ExpenseCategory.values.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: Icon(_getCategoryIcon(category), size: 16, color: isSelected ? Colors.white : null),
                            label: Text(_formatEnumName(category.name)),
                            selected: isSelected,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                            onSelected: (selected) {
                              if (selected) {
                                HapticFeedback.selectionClick();
                                setState(() { _selectedCategory = category; });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Column(
                      children: [
                        _buildKeypadRow(['1', '2', '3']),
                        const SizedBox(height: 12),
                        _buildKeypadRow(['4', '5', '6']),
                        const SizedBox(height: 12),
                        _buildKeypadRow(['7', '8', '9']),
                        const SizedBox(height: 12),
                        _buildKeypadRow(['.', '0', '⌫']),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        icon: Icon(_isEditMode ? Icons.check : Icons.save),
                        label: Text(
                          _isEditMode ? 'Update Spend' : 'Save Spend',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: amount > 0 ? _saveExpense : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onKeypadTap(key),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: key == '⌫' ? Colors.red : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountString) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an amount greater than 0')));
      return;
    }

    final repo = ref.read(expenseRepositoryProvider);
    const isarUser = ''; 

    if (_isEditMode) {
      final updated = widget.existingExpense!.copyWith(
        amount: amount,
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        category: _selectedCategory,
        date: _selectedDateTime,
        receiptImageUrl: _receiptImagePath,
        updatedAt: DateTime.now(),
      );

      await repo.updateExpense(updated);
      await PatternDetector.onExpenseAdded(updated);
    } else {
      final newExpense = Expense(
        id: const Uuid().v4(),
        userId: isarUser,
        amount: amount,
        currency: 'USD',
        category: _selectedCategory,
        date: _selectedDateTime,
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        receiptImageUrl: _receiptImagePath,
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

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day, picked.hour, picked.minute);
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
      case ExpenseCategory.other: return Icons.more_horiz;
    }
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}