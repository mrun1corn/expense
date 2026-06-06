import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  DateTime _selectedMonth = DateTime.now();

  Future<void> _showMonthPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5);
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() => _selectedMonth = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _showMonthPicker,
          ),
        ],
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final monthlyExpenses = expenses.where((e) =>
              e.date.month == _selectedMonth.month &&
              e.date.year == _selectedMonth.year).toList();

          if (monthlyExpenses.isEmpty) {
            return const Center(child: Text('No expenses found for this month.'));
          }

          final categoryTotals = <ExpenseCategory, double>{};
          var totalSpent = 0.0;
          for (final e in monthlyExpenses) {
            categoryTotals[e.category] = (categoryTotals[e.category] ?? 0.0) + e.amount;
            totalSpent += e.amount;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Summary: ${DateFormat('MMM yyyy').format(_selectedMonth)}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Total: \u0024${totalSpent.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: categoryTotals.entries.map((e) {
                      const fontSize = 16.0;
                      const radius = 50.0;
                      return PieChartSectionData(
                        color: Colors.primaries[e.key.index % Colors.primaries.length],
                        value: e.value,
                        title: '${(e.value / totalSpent * 100).toStringAsFixed(1)}%',
                        radius: radius,
                        titleStyle: const TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 2)],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Category Breakdown', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              ...categoryTotals.entries.map((e) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[e.key.index % Colors.primaries.length],
                    ),
                    title: Text(e.key.name.toUpperCase()),
                    trailing: Text('\u0024${e.value.toStringAsFixed(2)}'),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
