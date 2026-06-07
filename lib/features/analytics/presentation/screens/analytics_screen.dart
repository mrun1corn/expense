import 'package:expense/core/theme/app_theme.dart';
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
      setState(() => _selectedMonth = DateTime(date.year, date.month));
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

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            // 1. Calculate Monthly Expenses
            final monthlyExpenses = expenses.where((e) =>
                e.date.month == _selectedMonth.month &&
                e.date.year == _selectedMonth.year &&
                e.type == TransactionType.expense &&
                !e.isDeleted).toList();

            // 2. Previous Month Expenses (for delta change)
            final prevMonthDate = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
            final prevMonthExpenses = expenses.where((e) =>
                e.date.month == prevMonthDate.month &&
                e.date.year == prevMonthDate.year &&
                e.type == TransactionType.expense &&
                !e.isDeleted).toList();

            final totalSpent = monthlyExpenses.fold<double>(0.0, (sum, e) => sum + e.amount);
            final prevTotalSpent = prevMonthExpenses.fold<double>(0.0, (sum, e) => sum + e.amount);

            final deltaPercent = prevTotalSpent > 0
                ? ((totalSpent - prevTotalSpent) / prevTotalSpent) * 100
                : 0.0;

            // 3. Category breakdown
            final categoryTotals = <ExpenseCategory, double>{};
            for (final e in monthlyExpenses) {
              categoryTotals[e.category] = (categoryTotals[e.category] ?? 0.0) + e.amount;
            }

            // 4. Daily Spending Bar Chart totals
            final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
            final dailyTotals = List.generate(daysInMonth, (_) => 0.0);
            for (final e in monthlyExpenses) {
              if (e.date.day <= daysInMonth) {
                dailyTotals[e.date.day - 1] += e.amount;
              }
            }

            // X-axis values for daily spending
            final barGroups = List.generate(daysInMonth, (index) {
              return BarChartGroupData(
                x: index + 1,
                barRods: [
                  BarChartRodData(
                    toY: dailyTotals[index],
                    color: AppColors.getBrandPrimary(context),
                    width: daysInMonth > 30 ? 4 : 6,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              );
            });

            // 5. 6-Month Historical line chart
            final historicalMonths = List.generate(6, (i) {
              return DateTime(_selectedMonth.year, _selectedMonth.month - (5 - i), 1);
            });

            final historicalTotals = historicalMonths.map((m) {
              return expenses.where((e) =>
                  e.date.month == m.month &&
                  e.date.year == m.year &&
                  e.type == TransactionType.expense &&
                  !e.isDeleted
              ).fold<double>(0.0, (sum, e) => sum + e.amount);
            }).toList();

            final lineSpots = List.generate(6, (index) {
              return FlSpot(index.toDouble(), historicalTotals[index]);
            });

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ScreenHeader(
                    title: 'Analytics & Trends',
                    subtitle: 'Track spending patterns over time',
                    showBackButton: true,
                    action: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: _showMonthPicker,
                    ),
                  ),
                ),

                // Spending overview hero cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: AppShadows.getCardDecoration(context),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL SPENT',
                                  style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${totalSpent.toStringAsFixed(2)}',
                                  style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      deltaPercent >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                      size: 12,
                                      color: deltaPercent >= 0 ? AppColors.getDanger(context) : AppColors.getSuccess(context),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${deltaPercent >= 0 ? "+" : ""}${deltaPercent.toStringAsFixed(1)}% vs last month',
                                      style: AppTextStyles.captionBold(
                                        color: deltaPercent >= 0 ? AppColors.getDanger(context) : AppColors.getSuccess(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: AppShadows.getCardDecoration(context),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MONTHLY RANGE',
                                  style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('MMM yyyy').format(_selectedMonth),
                                  style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${monthlyExpenses.length} transactions',
                                  style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 6-Month Line Chart Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                      decoration: AppShadows.getCardDecoration(context),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '6-MONTH SPENDING TREND',
                            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 180,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final idx = value.toInt();
                                        if (idx >= 0 && idx < 6) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              DateFormat('MMM').format(historicalMonths[idx]),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.getFgSecondary(context),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: lineSpots,
                                    isCurved: true,
                                    barWidth: 4,
                                    color: AppColors.getBrandPrimary(context),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.getBrandPrimary(context).withOpacity(0.1),
                                    ),
                                    dotData: const FlDotData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Daily Bar Chart Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: AppShadows.getCardDecoration(context),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DAILY SPENDING BREAKDOWN',
                            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 180,
                            child: BarChart(
                              BarChartData(
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final day = value.toInt();
                                        if (day == 1 || day == 10 || day == 20 || day == daysInMonth) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              '$day',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.getFgSecondary(context),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: barGroups,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Category Breakdown title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      'CATEGORY SPLIT',
                      style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                    ),
                  ),
                ),

                // Category Pie Chart & Breakdown
                if (monthlyExpenses.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No expenses recorded for this month.')),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Container(
                        decoration: AppShadows.getCardDecoration(context),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 180,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: categoryTotals.entries.map((entry) {
                                    final cat = entry.key;
                                    final amount = entry.value;
                                    final pct = (amount / totalSpent * 100).toStringAsFixed(1);
                                    return PieChartSectionData(
                                      color: _getCategoryColor(cat),
                                      value: amount,
                                      title: '$pct%',
                                      radius: 45,
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [Shadow(blurRadius: 2)],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...categoryTotals.entries.map((entry) {
                              final cat = entry.key;
                              final amount = entry.value;
                              final catColor = _getCategoryColor(cat);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: catColor.withOpacity(0.1),
                                  child: Icon(_getCategoryIcon(cat), color: catColor, size: 18),
                                ),
                                title: Text(
                                  _formatEnumName(cat.name),
                                  style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                ),
                                trailing: Text(
                                  '\$${amount.toStringAsFixed(2)}',
                                  style: AppTextStyles.monospace(
                                    14,
                                    color: AppColors.getFgPrimary(context),
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SliverPadding(padding: EdgeInsets.only(bottom: 96)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
