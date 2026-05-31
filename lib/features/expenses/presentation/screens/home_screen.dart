import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/expenses/presentation/providers/sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';
  ExpenseCategory? _selectedCategory;
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Trigger background sync listeners
    ref.watch(activeCloudSyncProvider);

    final expensesAsync = ref.watch(expensesStreamProvider);
    final totalSpentAsync = ref.watch(totalThisMonthProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Hot reload/refresh stream
            ref.invalidate(expensesStreamProvider);
            ref.invalidate(totalThisMonthProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Premium App Bar & Search Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Spend',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            DateFormat('EEEE, MMM d').format(DateTime.now()),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      // Month Selector Badge
                      ActionChip(
                        avatar: Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(
                          DateFormat('MMMM yyyy').format(_selectedMonth),
                        ),
                        onPressed: () => _showMonthPicker(context),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Box
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SearchBar(
                    hintText: 'Search spending...',
                    leading: const Icon(Icons.search),
                    trailing: _searchQuery.isNotEmpty
                        ? [
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            ),
                          ]
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              // Glassmorphism Spending Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(
                            context,
                          ).colorScheme.secondaryContainer.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Total',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                            const Icon(Icons.trending_up, color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 8),
                        totalSpentAsync.when(
                          data: (total) => Text(
                            '💵${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          loading: () => const SizedBox(
                            height: 36,
                            width: 36,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, _) => Text(
                            '💵0.00',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Budget progress bar (Mocked for Guest mode until Budget Screen is fully set up)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Budget Progress',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withOpacity(0.7),
                                  ),
                            ),
                            Text(
                              '70% of 💵10,000',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.70,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Filter Chips
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ...ExpenseCategory.values.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: Icon(
                              _getCategoryIcon(category),
                              size: 16,
                            ),
                            label: Text(_formatEnumName(category.name)),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Expenses List Header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Recent Spending',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Expenses List Content
              expensesAsync.when(
                data: (list) {
                  // Filter list locally by search query, category, and month
                  final filteredList = list.where((e) {
                    final matchesSearch =
                        e.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        (e.note != null &&
                            e.note!.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ));
                    final matchesCategory =
                        _selectedCategory == null ||
                        e.category == _selectedCategory;
                    final matchesMonth =
                        e.date.month == _selectedMonth.month &&
                        e.date.year == _selectedMonth.year;
                    return matchesSearch && matchesCategory && matchesMonth;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Semantics(
                              label: 'No expenses tracked yet',
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No expenses found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Try modifying your search or add a new expense.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Group expenses by calendar date
                  final groupedExpenses = <String, List<Expense>>{};
                  for (final exp in filteredList) {
                    final dateStr = DateFormat(
                      'EEEE, MMMM d, yyyy',
                    ).format(exp.date);
                    if (groupedExpenses[dateStr] == null) {
                      groupedExpenses[dateStr] = [];
                    }
                    groupedExpenses[dateStr]!.add(exp);
                  }

                  final dateKeys = groupedExpenses.keys.toList();

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dateStr = dateKeys[index];
                        final dayExpenses = groupedExpenses[dateStr]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                8,
                              ),
                              child: Text(
                                dateStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            // List of expenses for this date
                            ...dayExpenses.map((exp) {
                              return Slidable(
                                key: ValueKey(exp.id),
                                endActionPane: ActionPane(
                                  motion: const BehindMotion(),
                                  dismissible: DismissiblePane(
                                    onDismissed: () {
                                      _deleteExpense(ref, exp);
                                    },
                                  ),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        _deleteExpense(ref, exp);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      _getCategoryIcon(exp.category),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                    exp.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_formatEnumName(exp.category.name)} • ${DateFormat('h:mm a').format(exp.date)}',
                                  ),
                                  trailing: Text(
                                    '💵${exp.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  onTap: () {
                                    context.push(
                                      '/expense/${exp.id}',
                                      extra: exp,
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        );
                      },
                      childCount: dateKeys.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Spend'),
        onPressed: () {
          context.push('/add');
        },
      ),
    );
  }

  // Deletes an expense and shows an undo snackbar
  void _deleteExpense(WidgetRef ref, Expense exp) {
    ref.read(expenseRepositoryProvider).deleteExpense(exp.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${exp.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            ref.read(expenseRepositoryProvider).addExpense(exp);
          },
        ),
      ),
    );
  }

  // Visual icons for categories
  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.utilities:
        return Icons.electrical_services;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.health:
        return Icons.medical_services;
      case ExpenseCategory.education:
        return Icons.school;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  // Capitalize enum name nicely
  String _formatEnumName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  // Opens a month and year selector dialog
  Future<void> _showMonthPicker(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'SELECT MONTH',
    );
    if (selected != null) {
      setState(() {
        _selectedMonth = DateTime(selected.year, selected.month);
      });
    }
  }
}
