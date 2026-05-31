import 'package:expense/features/budgets/domain/models/budget.dart';
import 'package:expense/features/budgets/presentation/providers/budget_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _showMonthPicker(BuildContext context) async {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _showMonthPicker(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddBudgetSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Set Budget Limit'),
      ),
      body: expensesAsync.when(
        data: (expenses) => budgetsAsync.when(
          data: (budgets) {
            // Filter expenses for selected month & year
            final monthlyExpenses = expenses.where((e) =>
                e.date.month == _selectedMonth.month &&
                e.date.year == _selectedMonth.year).toList();

            // Calculate spent amounts per category dynamically
            final spentByCategory = <ExpenseCategory, double>{};
            for (final exp in monthlyExpenses) {
              spentByCategory[exp.category] = (spentByCategory[exp.category] ?? 0.0) + exp.amount;
            }

            // Total budget limits & total spent within budget categories
            double totalBudget = 0.0;
            double totalSpent = 0.0;

            final budgetItemsList = budgets.map((b) {
              final spent = spentByCategory[b.category] ?? 0.0;
              totalBudget += b.limitAmount;
              totalSpent += spent;

              return _BudgetItem(
                budget: b,
                spentAmount: spent,
                onEdit: () => _openAddBudgetSheet(context, b),
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

            return CustomScrollView(
              slivers: [
                // Month header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(_selectedMonth),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${budgets.length} budget limits configured',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Total Summary Card
                if (budgets.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                                Theme.of(context).colorScheme.surface,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'All Budgets Progress',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '💵${totalSpent.toStringAsFixed(2)} spent',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    'of 💵${totalBudget.toStringAsFixed(2)} limit',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: totalPercent,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    totalPercent > 0.9 ? Colors.red : (totalPercent > 0.75 ? Colors.orange : Colors.green),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(totalPercent * 100).toStringAsFixed(0)}% consumed',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: totalPercent > 0.9 ? Colors.red : (totalPercent > 0.75 ? Colors.orange : Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                if (budgets.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline_rounded,
                              size: 72,
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Budgets Set Yet',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Setting category spending limits keeps your expenses optimized and triggers custom warning notifications before you overspend.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, height: 1.3),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _openAddBudgetSheet(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Set up your first limit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => budgetItemsList[index],
                        childCount: budgetItemsList.length,
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
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final Budget budget;
  final double spentAmount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetItem({
    required this.budget,
    required this.spentAmount,
    required this.onEdit,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final limit = budget.limitAmount;
    final percent = limit > 0 ? (spentAmount / limit).clamp(0.0, 1.0) : 0.0;
    final isOver = spentAmount > limit;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(budget.category),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatEnumName(budget.category.name),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '💵${spentAmount.toStringAsFixed(2)} of 💵${limit.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(percent * 100).toStringAsFixed(0)}% used',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isOver ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.green),
                  ),
                ),
                if (isOver)
                  const Text(
                    'Limit exceeded!',
                    style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBudgetBottomSheet extends ConsumerStatefulWidget {
  final DateTime selectedMonth;
  final Budget? existingBudget;

  const _AddBudgetBottomSheet({
    required this.selectedMonth,
    this.existingBudget,
  });

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.existingBudget != null ? 'Edit Spending Limit' : 'Configure Spending Limit',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<ExpenseCategory>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Select Category',
              border: OutlineInputBorder(),
            ),
            items: ExpenseCategory.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(_formatEnumName(cat.name)),
              );
            }).toList(),
            onChanged: widget.existingBudget != null
                ? null // category cannot be changed on edit mode for consistency
                : (val) {
                    if (val != null) {
                      setState(() {
                        _category = val;
                      });
                    }
                  },
          ),
          const SizedBox(height: 16),
          // Standard numerical TextFormField (Bypasses clunky keypad bugs)
          TextFormField(
            controller: _limitController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              labelText: 'Limit Amount (\$)',
              hintText: '0.00',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
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
                        final newBudget = Budget(
                          id: id,
                          userId: '',
                          category: _category,
                          limitAmount: limit,
                          currency: 'USD',
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
