import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/core/extensions/double_ext.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:expense/features/expenses/presentation/widgets/transaction_list_item.dart';
import 'package:expense/l10n/app_localizations.dart';
import 'package:expense/features/expenses/presentation/widgets/expense_ui_utils.dart';

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

  // We use ExpenseUiUtils for category styling now

  Color _getPaymentSystemColor(String systemName) {
    final type = PaymentSystemsManager.getSystemTypeColor(systemName);
    switch (type) {
      case 'mfs':
        return Colors.teal;
      case 'rtp':
        return Colors.blue;
      case 'wallet':
        return Colors.deepPurple;
      case 'bank':
        return Colors.brown;
      case 'neo':
        return Colors.orange;
      case 'card':
        return Colors.green;
      case 'cbdc':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _deleteExpense(WidgetRef ref, Expense exp) {
    ref.read(expenseRepositoryProvider).deleteExpense(exp.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)?.deleted ?? "Deleted"} "${exp.title}"'),
        action: SnackBarAction(
          label: AppLocalizations.of(context)?.undo ?? 'UNDO',
          onPressed: () {
            ref.read(expenseRepositoryProvider).addExpense(exp);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We fetch historical data (6 months) for the trendline
    final allExpensesAsync = ref.watch(expensesStreamProvider);
    // We fetch the currently selected month
    final monthlyExpensesAsync = ref.watch(monthlyExpensesStreamProvider(DateTime(_selectedMonth.year, _selectedMonth.month)));
    // We fetch the previous month
    final prevMonthDate = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    final prevMonthlyExpensesAsync = ref.watch(monthlyExpensesStreamProvider(prevMonthDate));
    
    final currencyCode = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: allExpensesAsync.when(
          data: (allExpenses) {
            final monthlyData = monthlyExpensesAsync.valueOrNull ?? [];
            final prevMonthlyData = prevMonthlyExpensesAsync.valueOrNull ?? [];
            // 1. Calculate Monthly Expenses
            final monthlyExpenses = monthlyData.where((e) => e.type == TransactionType.expense).toList();

            final allMonthlyTransactions = monthlyData.toList()
              ..sort((a, b) => b.date.compareTo(a.date));

            // Group transactions by date
            final groupedTransactions = <DateTime, List<Expense>>{};
            for (final exp in allMonthlyTransactions) {
              final dateKey = DateTime(exp.date.year, exp.date.month, exp.date.day);
              if (!groupedTransactions.containsKey(dateKey)) {
                groupedTransactions[dateKey] = [];
              }
              groupedTransactions[dateKey]!.add(exp);
            }
            final sortedDates = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));

            // 2. Previous Month Expenses (for delta change)
            final prevMonthExpenses = prevMonthlyData.where((e) => e.type == TransactionType.expense).toList();

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

            // 3b. Payment System breakdown
            final paymentSystemTotals = <String, double>{};
            for (final e in monthlyExpenses) {
              if (e.paymentSystem != null && e.paymentSystem!.isNotEmpty) {
                paymentSystemTotals[e.paymentSystem!] = (paymentSystemTotals[e.paymentSystem!] ?? 0.0) + e.amount;
              }
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
              return allExpenses.where((e) =>
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
                    showBackButton: Navigator.canPop(context),
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
                                    totalSpent.toCurrencyString(currencyCode),
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
                                      color: ExpenseUiUtils.getCategoryColor(cat),
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
                              final catColor = ExpenseUiUtils.getCategoryColor(cat);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: catColor.withOpacity(0.1),
                                  child: Icon(ExpenseUiUtils.getCategoryIcon(cat), color: catColor, size: 18),
                                ),
                                title: Text(
                                  ExpenseUiUtils.formatEnumName(cat.name),
                                  style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                ),
                                trailing: Text(
                                  amount.toCurrencyString(currencyCode),
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

                // Payment Systems Split title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      'PAYMENT SYSTEMS SPLIT',
                      style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                    ),
                  ),
                ),

                // Payment Systems breakdown progress bars
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
                        child: paymentSystemTotals.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    'No payment systems used this month.',
                                    style: AppTextStyles.bodyMd(color: AppColors.getFgSecondary(context)),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...(paymentSystemTotals.entries.toList()
                                        ..sort((a, b) => b.value.compareTo(a.value)))
                                      .map((entry) {
                                    final systemName = entry.key;
                                    final amount = entry.value;
                                    final pct = totalSpent > 0 ? (amount / totalSpent * 100).toStringAsFixed(1) : '0.0';
                                    final color = _getPaymentSystemColor(systemName);
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                systemName,
                                                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                              ),
                                              Text(
                                                '${amount.toCurrencyString(currencyCode)} ($pct%)',
                                                style: AppTextStyles.monospace(
                                                  14,
                                                  color: AppColors.getFgPrimary(context),
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: totalSpent > 0 ? amount / totalSpent : 0.0,
                                              backgroundColor: color.withOpacity(0.1),
                                              valueColor: AlwaysStoppedAnimation<Color>(color),
                                              minHeight: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],

                // Transactions list title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      AppLocalizations.of(context)?.transactions.toUpperCase() ?? 'TRANSACTIONS',
                      style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                    ),
                  ),
                ),

                if (allMonthlyTransactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(AppLocalizations.of(context)?.noTransactionsThisMonth ?? 'No transactions recorded for this month.')
                      ),
                    ),
                  )
                else
                  ...sortedDates.map((date) {
                    final dayExpenses = groupedTransactions[date]!;
                    final now = DateTime.now();
                    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                    final isYesterday = date.year == now.year && date.month == now.month && date.day == now.day - 1;
                    
                    String dateHeader;
                    if (isToday) {
                      dateHeader = 'Today';
                    } else if (isYesterday) {
                      dateHeader = 'Yesterday';
                    } else {
                      dateHeader = DateFormat('MMM d, yyyy').format(date);
                    }

                    return SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(36, 16, 20, 4),
                            child: Text(
                              dateHeader.toUpperCase(),
                              style: AppTextStyles.captionBold(color: AppColors.getFgSecondary(context)),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final exp = dayExpenses[index];
                              return TransactionListItem(
                                expense: exp,
                                currencyCode: currencyCode,
                                onDelete: () => _deleteExpense(ref, exp),
                                showDate: false,
                              );
                            },
                            childCount: dayExpenses.length,
                          ),
                        ),
                      ],
                    );
                  }),

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
