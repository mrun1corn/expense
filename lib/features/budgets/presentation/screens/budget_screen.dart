import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/budgets/domain/models/budget.dart';
import 'package:expense/features/budgets/presentation/providers/budget_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/core/extensions/double_ext.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  DateTime _selectedMonth = DateTime.now();

  Future<void> _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  void _openAddBudgetSheet(BuildContext context, [Budget? existingBudget]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBudgetBottomSheet(
        selectedMonth: _selectedMonth,
        existingBudget: existingBudget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetsAsync = ref.watch(budgetsStreamProvider(_selectedMonth));
    final expensesAsync = ref.watch(expensesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyCode = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) => budgetsAsync.when(
            data: (budgets) {
              final monthlyExpenses = expenses.where((e) =>
                  e.date.month == _selectedMonth.month &&
                  e.date.year == _selectedMonth.year &&
                  e.type == TransactionType.expense &&
                  !e.isDeleted).toList();

              final spentByCategory = <ExpenseCategory, double>{};
              for (final exp in monthlyExpenses) {
                spentByCategory[exp.category] = (spentByCategory[exp.category] ?? 0.0) + exp.amount;
              }

              var totalBudget = 0.0;
              var totalSpent = 0.0;

              final budgetItemsList = budgets.map((b) {
                final spent = spentByCategory[b.category] ?? 0.0;
                totalBudget += b.limitAmount;
                totalSpent += spent;

                return _BudgetItem(
                  budget: b,
                  spentAmount: spent,
                  onEdit: () => _openAddBudgetSheet(context, b),
                  currencyCode: currencyCode,
                  onDelete: () async {
                    await ref.read(budgetRepositoryProvider).deleteBudget(b.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Budget limit deleted')),
                      );
                    }
                  },
                );
              }).toList();

              final totalPercent = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
              final remaining = (totalBudget - totalSpent).clamp(0.0, double.infinity);

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ScreenHeader(
                      title: 'Budget Manager',
                      subtitle: 'AI-suggested limits per category',
                      showBackButton: true,
                      action: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _openAddBudgetSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month_outlined),
                            onPressed: () => _showMonthPicker(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Month Overview Card (hero/dark)
                  SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
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
                            DateFormat('MMMM yyyy').format(_selectedMonth).toUpperCase(),
                            style: AppTextStyles.overline(
                              color: AppColors.getHeroFgMuted(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${totalBudget.toCurrencySymbol(currencyCode)}${totalBudget.toStringAsFixed(0)}',
                            style: AppTextStyles.monospace(
                              32,
                              color: AppColors.getHeroFg(context),
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Spent: ${totalSpent.toCurrencySymbol(currencyCode)}${totalSpent.toStringAsFixed(0)} · Remaining: ${remaining.toCurrencySymbol(currencyCode)}${remaining.toStringAsFixed(0)}',
                            style: AppTextStyles.bodySm(
                              color: AppColors.getHeroFgMuted(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: SizedBox(
                              height: 6,
                              child: LinearProgressIndicator(
                                value: totalPercent,
                                backgroundColor: const Color(0xFF2A2A2A),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  totalPercent > 0.9
                                      ? AppColors.dangerLight
                                      : (totalPercent > 0.75
                                          ? AppColors.warningLight
                                          : (isDark ? AppColors.fgPrimaryDark : AppColors.heroFgLight)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Category Budgets list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'CATEGORY BUDGETS',
                      style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                    ),
                  ),
                ),

                if (budgets.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_rounded,
                              size: 72,
                              color: AppColors.getFgTertiary(context),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Budgets Set Yet',
                              style: AppTextStyles.headingLg(color: AppColors.getFgPrimary(context)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Setting category spending limits keeps your expenses optimized and triggers custom warning notifications before you overspend.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.4),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _openAddBudgetSheet(context),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Set up your first limit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.getBrandPrimary(context),
                                foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => budgetItemsList[index],
                        childCount: budgetItemsList.length,
                      ),
                    ),
                  ),

                // AI Recommendation block
                if (budgets.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.getBgSunken(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: AppColors.getInfo(context),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Recommendation',
                                    style: AppTextStyles.captionBold(color: AppColors.getInfo(context)),
                                  ),
                                  const SizedBox(height: 4),
                                    Text(
                                      'Your spending on Utilities is currently under budget. AI suggests you could reallocate ${100.0.toCurrencySymbol(currencyCode)}100 of unused limit to Transport based on your 30-day pattern.',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.4),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Adjust Budgets with AI button
                if (budgets.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: const Text(
                            'Adjust Budgets with AI',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getBrandPrimary(context),
                            foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 1,
                          ),
                          onPressed: () {
                            context.push('/chat');
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading expenses: $e')),
      ),
    ),
  );
}
}

class _BudgetItem extends StatelessWidget {
  const _BudgetItem({
    required this.budget,
    required this.spentAmount,
    required this.onEdit,
    required this.onDelete,
    required this.currencyCode,
  });
  final Budget budget;
  final double spentAmount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String currencyCode;

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

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Colors.orange;
      case ExpenseCategory.transport: return Colors.blue;
      case ExpenseCategory.shopping: return Colors.purple;
      case ExpenseCategory.utilities: return Colors.amber;
      case ExpenseCategory.health: return Colors.red;
      case ExpenseCategory.entertainment: return Colors.green;
      case ExpenseCategory.education: return Colors.indigo;
      case ExpenseCategory.salary: return Colors.teal;
      case ExpenseCategory.business: return Colors.cyan;
      case ExpenseCategory.investment: return Colors.lightGreen;
      case ExpenseCategory.gift: return Colors.deepPurple;
      case ExpenseCategory.friend: return Colors.brown;
      case ExpenseCategory.bank: return Colors.blueGrey;
      case ExpenseCategory.family: return Colors.pink;
      case ExpenseCategory.other: return Colors.grey;
    }
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final limit = budget.limitAmount;
    final percent = limit > 0 ? (spentAmount / limit).clamp(0.0, 1.0) : 0.0;
    final isOver = spentAmount > limit;
    final catColor = _getCategoryColor(budget.category);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // AI suggestions flag (demo auto suggestion tag)
    final isAiSuggested = budget.category == ExpenseCategory.food || budget.category == ExpenseCategory.transport;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppShadows.getCardDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.getBgSunken(context),
                radius: 18,
                child: Icon(
                  _getCategoryIcon(budget.category),
                  color: catColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatEnumName(budget.category.name),
                          style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                        ),
                        if (isAiSuggested) ...[
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.getInfoBg(context),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome, size: 8, color: AppColors.getInfo(context)),
                                const SizedBox(width: 2),
                                Text(
                                  'AI Suggested',
                                  style: AppTextStyles.captionBold(color: AppColors.getInfo(context)).copyWith(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${spentAmount.toCurrencySymbol(currencyCode)}${spentAmount.toStringAsFixed(0)} of ${limit.toCurrencySymbol(currencyCode)}${limit.toStringAsFixed(0)} limit',
                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20, color: AppColors.getDanger(context)),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  percent > 0.90
                      ? AppColors.getDanger(context)
                      : (percent >= 0.70
                          ? AppColors.getWarning(context)
                          : AppColors.getSuccess(context)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percent * 100).toStringAsFixed(0)}% used',
                style: AppTextStyles.captionBold(
                  color: percent > 0.90
                      ? AppColors.getDanger(context)
                      : (percent >= 0.70 ? AppColors.getWarning(context) : AppColors.getSuccess(context)),
                ),
              ),
              if (isOver)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getDangerBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    'Over Budget',
                    style: AppTextStyles.captionBold(color: AppColors.getDanger(context)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddBudgetBottomSheet extends ConsumerStatefulWidget {
  const _AddBudgetBottomSheet({
    required this.selectedMonth,
    this.existingBudget,
  });
  final DateTime selectedMonth;
  final Budget? existingBudget;

  @override
  ConsumerState<_AddBudgetBottomSheet> createState() => _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends ConsumerState<_AddBudgetBottomSheet> {
  final _limitController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingBudget != null) {
      _category = widget.existingBudget!.category;
      _limitController.text = widget.existingBudget!.limitAmount.toString();
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyCode = ref.watch(currencyProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getBgSurface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: isDark ? const Border(top: BorderSide(color: Color(0x12FFFFFF))) : null,
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.getBgSunken(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.existingBudget != null ? 'Edit Spending Limit' : 'Configure Spending Limit',
            style: AppTextStyles.headingLg(color: AppColors.getFgPrimary(context)),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<ExpenseCategory>(
            initialValue: _category,
            decoration: InputDecoration(
              labelText: 'Select Category',
              filled: true,
              fillColor: AppColors.getBgSunken(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            items: ExpenseCategory.values.where((c) => c.index <= ExpenseCategory.education.index).map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(_formatEnumName(cat.name)),
              );
            }).toList(),
            onChanged: widget.existingBudget != null
                ? null
                : (val) {
                    if (val != null) {
                      setState(() {
                        _category = val;
                      });
                    }
                  },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _limitController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Limit Amount (${0.0.toCurrencySymbol(currencyCode)})',
              hintText: '0.00',
              prefixText: '${0.0.toCurrencySymbol(currencyCode)} ',
              filled: true,
              fillColor: AppColors.getBgSunken(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getBrandPrimary(context),
                foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isSaving
                  ? null
                  : () async {
                      final limit = double.tryParse(_limitController.text.trim()) ?? 0.0;
                      if (limit <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid amount greater than 0')),
                        );
                        return;
                      }

                      setState(() {
                        _isSaving = true;
                      });

                      try {
                        final id = widget.existingBudget?.id ?? const Uuid().v4();
                        final currentUser = ref.read(authStateProvider).valueOrNull;
                        final userId = currentUser?.id ?? '';
                        
                        final newBudget = Budget(
                          id: id,
                          userId: userId,
                          category: _category,
                          limitAmount: limit,
                          currency: currencyCode,
                          month: widget.selectedMonth.month,
                          year: widget.selectedMonth.year,
                          createdAt: DateTime.now(),
                        );

                        await ref.read(budgetRepositoryProvider).saveBudget(newBudget);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.existingBudget != null
                                    ? 'Spending limit updated successfully!'
                                    : 'New budget limit configured!',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save budget: $e')),
                          );
                        }
                      } finally {
                        setState(() {
                          _isSaving = false;
                        });
                      }
                    },
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : const Text('Save Limit', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
