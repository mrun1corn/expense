import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/budgets/presentation/providers/budget_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/expenses/presentation/providers/sync_provider.dart';
import 'package:expense/features/home/presentation/screens/main_shell_screen.dart';
import 'package:expense/core/extensions/double_ext.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:expense/features/expenses/presentation/widgets/transaction_list_item.dart';
import 'package:expense/features/expenses/presentation/widgets/expense_ui_utils.dart';
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _selectedMonth = DateTime.now();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

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

  // We use TransactionListItem for UI now.

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

  @override
  Widget build(BuildContext context) {
    // Trigger background sync listeners
    ref.watch(activeCloudSyncProvider);

    final expensesAsync = ref.watch(monthlyExpensesStreamProvider(DateTime(_selectedMonth.year, _selectedMonth.month)));
    final prevMonthExpensesAsync = ref.watch(monthlyExpensesStreamProvider(DateTime(_selectedMonth.year, _selectedMonth.month - 1)));
    final budgetsAsync = ref.watch(budgetsStreamProvider(_selectedMonth));
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final userName = currentUser?.displayName ?? 'Alex';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyCode = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(monthlyExpensesStreamProvider(DateTime(_selectedMonth.year, _selectedMonth.month)))
              ..invalidate(budgetsStreamProvider(_selectedMonth));
          },
          child: expensesAsync.when(
            data: (expenses) => budgetsAsync.when(
              data: (budgets) {
                // Filter this month's expenses
                final thisMonthExpenses = expenses.where((e) =>
                    !e.isDeleted).toList();

                final now = DateTime.now();
                final isCurrentMonth = now.month == _selectedMonth.month && now.year == _selectedMonth.year;

                final todayExpenses = thisMonthExpenses
                    .where((e) =>
                        e.date.day == now.day &&
                        e.date.month == now.month &&
                        e.date.year == now.year &&
                        e.type == TransactionType.expense)
                    .fold<double>(0, (sum, e) => sum + e.amount);

                final daysPassed = isCurrentMonth
                    ? now.day
                    : DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

                final totalIncome = thisMonthExpenses
                    .where((e) => e.type == TransactionType.income)
                    .fold<double>(0, (sum, e) => sum + e.amount);

                final totalExpenses = thisMonthExpenses
                    .where((e) => e.type == TransactionType.expense)
                    .fold<double>(0, (sum, e) => sum + e.amount);

                final netSaved = totalIncome - totalExpenses;
                final dailyAverage = totalExpenses / (daysPassed > 0 ? daysPassed : 1);

                final isBn = Localizations.localeOf(context).languageCode == 'bn';
                final remainingTitle = isBn ? 'বাকি বাজেট' : 'REMAINING';
                final spentText = isBn ? 'ব্যয়' : 'spent';
                final todayTitle = isBn ? 'আজকের খরচ' : 'TODAY';
                final spentTodayText = isBn ? 'আজকে ব্যয়' : 'spent today';
                final dailyAverageTitle = isBn ? 'দৈনিক গড়' : 'DAILY AVERAGE';
                final averagePerDayText = isBn ? 'প্রতিদিনের গড়' : 'average per day';

                // Calculate budget parameters
                final spentByCategory = <ExpenseCategory, double>{};
                for (final exp in thisMonthExpenses) {
                  if (exp.type == TransactionType.expense) {
                    spentByCategory[exp.category] = (spentByCategory[exp.category] ?? 0.0) + exp.amount;
                  }
                }

                var totalBudgetLimit = 0.0;
                for (final b in budgets) {
                  totalBudgetLimit += b.limitAmount;
                }

                // Default budget threshold if none configured
                if (totalBudgetLimit == 0.0) {
                  totalBudgetLimit = 1500.0;
                }

                final percent = (totalExpenses / totalBudgetLimit).clamp(0.0, 1.0);
                final remaining = (totalBudgetLimit - totalExpenses).clamp(0.0, double.infinity);

                // Calculate dynamic delta change vs last month
                final prevMonthExpenses = prevMonthExpensesAsync.valueOrNull ?? [];
                final lastMonthExpensesList = prevMonthExpenses.where((e) =>
                    e.type == TransactionType.expense &&
                    !e.isDeleted).toList();
                final lastMonthTotal = lastMonthExpensesList.fold<double>(0, (sum, e) => sum + e.amount);

                final deltaPercent = lastMonthTotal > 0
                    ? ((totalExpenses - lastMonthTotal) / lastMonthTotal) * 100
                    : 0;

                // Filter for recent transactions
                final sortedRecent = List<Expense>.from(thisMonthExpenses)
                  ..sort((a, b) => b.date.compareTo(a.date));
                final recentThree = sortedRecent.take(3).toList();

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Top Bar Header
                    SliverToBoxAdapter(
                      child: ScreenHeader(
                        title: DateFormat('MMMM yyyy').format(_selectedMonth),
                        overline: '${_getGreeting()}, ${userName.toUpperCase()}',
                        action: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => _showMonthPicker(context),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.getFgPrimary(context),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.analytics_outlined),
                              onPressed: () => context.push('/analytics'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.auto_awesome),
                              color: AppColors.getInfo(context),
                              onPressed: () => context.push('/settings/notifications'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Total Spent Hero Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: GestureDetector(
                          onTap: () => context.push('/analytics'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.getHeroBg(context),
                              borderRadius: BorderRadius.circular(16),
                              border: isDark ? Border.all(color: const Color(0x1FFFFFFF)) : null,
                              boxShadow: AppShadows.getShadow1(context),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.totalSpent.toUpperCase(),
                                      style: AppTextStyles.overline(color: AppColors.getHeroFgMuted(context)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      totalExpenses.toCurrencyString(currencyCode),
                                      style: AppTextStyles.monospace(
                                        32,
                                        color: AppColors.getHeroFg(context),
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'of ${totalBudgetLimit.toCurrencySymbol(currencyCode)}${totalBudgetLimit.toStringAsFixed(0)} budget',
                                      style: AppTextStyles.bodySm(color: AppColors.getHeroFgMuted(context)),
                                    ),
                                    const SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: SizedBox(
                                        height: 6,
                                        child: LinearProgressIndicator(
                                          value: percent,
                                          backgroundColor: const Color(0x22FFFFFF),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            percent > 0.9
                                                ? AppColors.dangerLight
                                                : (percent > 0.75
                                                    ? AppColors.warningLight
                                                    : AppColors.getHeroFg(context)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${0.0.toCurrencySymbol(currencyCode)}0',
                                          style: AppTextStyles.caption(color: AppColors.getHeroFgMuted(context)),
                                        ),
                                        Text(
                                          '${remaining.toCurrencySymbol(currencyCode)}${remaining.toStringAsFixed(0)} left',
                                          style: AppTextStyles.captionBold(color: AppColors.getHeroFg(context)),
                                        ),
                                        Text(
                                          '${totalBudgetLimit.toCurrencySymbol(currencyCode)}${totalBudgetLimit.toStringAsFixed(0)}',
                                          style: AppTextStyles.caption(color: AppColors.getHeroFgMuted(context)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: deltaPercent >= 0
                                          ? (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2))
                                          : (isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          deltaPercent >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                          size: 10,
                                          color: deltaPercent >= 0 ? AppColors.getDanger(context) : AppColors.getSuccess(context),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${deltaPercent >= 0 ? "+" : "-"}${deltaPercent.abs().toStringAsFixed(0)}% vs last month',
                                          style: AppTextStyles.captionBold(
                                            color: deltaPercent >= 0 ? AppColors.getDanger(context) : AppColors.getSuccess(context),
                                          ),
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
                    ),

                    // Quick Stats Row (2 columns, 12px gap)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => context.push('/budgets'),
                                  child: Container(
                                    decoration: AppShadows.getCardDecoration(context, radius: 12),
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              remainingTitle.toUpperCase(),
                                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                            ),
                                            Icon(Icons.pie_chart_outline_rounded, size: 16, color: AppColors.getFgTertiary(context)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${remaining.toCurrencySymbol(currencyCode)}${remaining.toStringAsFixed(0)}',
                                          style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${totalExpenses.toCurrencySymbol(currencyCode)}${totalExpenses.toStringAsFixed(0)} $spentText',
                                          style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => context.push('/analytics'),
                                  child: Container(
                                    decoration: AppShadows.getCardDecoration(context, radius: 12),
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (isCurrentMonth ? todayTitle : dailyAverageTitle).toUpperCase(),
                                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                            ),
                                            Icon(
                                              isCurrentMonth ? Icons.today_rounded : Icons.speed_rounded,
                                              size: 16,
                                              color: AppColors.getFgTertiary(context),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          isCurrentMonth
                                              ? '${todayExpenses.toCurrencySymbol(currencyCode)}${todayExpenses.toStringAsFixed(0)}'
                                              : '${dailyAverage.toCurrencySymbol(currencyCode)}${dailyAverage.toStringAsFixed(0)}',
                                          style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isCurrentMonth ? spentTodayText : averagePerDayText,
                                          style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Spending Breakdown Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.spendingBreakdown.toUpperCase(),
                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Material(
                                color: AppColors.getBrandPrimary(context).withOpacity(0.08),
                                child: InkWell(
                                  onTap: () => context.push('/budgets'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Manage Budgets',
                                          style: AppTextStyles.captionBold(
                                            color: AppColors.getBrandPrimary(context),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 14,
                                          color: AppColors.getBrandPrimary(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Spending Breakdown progress bars (compact - 5 categories)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Container(
                          decoration: AppShadows.getCardDecoration(context),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: () {
                              final activeCategories = spentByCategory.entries.toList()
                                ..sort((a, b) => b.value.compareTo(a.value));
                              
                              if (activeCategories.isEmpty) {
                                return [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      'No expenses registered yet.',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                    ),
                                  )
                                ];
                              }

                              return activeCategories.take(5).map((entry) {
                                final cat = entry.key;
                                final catSpent = entry.value;
                                final catPercent = totalExpenses > 0 ? (catSpent / totalExpenses) : 0.0;
                                final catColor = ExpenseUiUtils.getCategoryColor(cat);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Icon(ExpenseUiUtils.getCategoryIcon(cat), size: 14, color: catColor),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          ExpenseUiUtils.formatEnumName(cat.name),
                                          style: AppTextStyles.bodySm(
                                            color: AppColors.getFgPrimary(context),
                                          ).copyWith(fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: SizedBox(
                                            height: 6,
                                            child: LinearProgressIndicator(
                                              value: catPercent,
                                              backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
                                              valueColor: AlwaysStoppedAnimation<Color>(catColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 32,
                                        child: Text(
                                          '${(catPercent * 100).toStringAsFixed(0)}%',
                                          textAlign: TextAlign.right,
                                          style: AppTextStyles.captionBold(
                                            color: AppColors.getFgSecondary(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            }(),
                          ),
                        ),
                      ),
                    ),

                    // Recent Transactions Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.recentTransactions.toUpperCase(),
                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Material(
                                color: AppColors.getBrandPrimary(context).withOpacity(0.08),
                                child: InkWell(
                                  onTap: () => context.push('/analytics'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'See All',
                                          style: AppTextStyles.captionBold(
                                            color: AppColors.getBrandPrimary(context),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 14,
                                          color: AppColors.getBrandPrimary(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Recent Transactions Content
                    if (recentThree.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No transactions recorded this month.',
                              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final exp = recentThree[index];
                              return TransactionListItem(
                                expense: exp,
                                currencyCode: currencyCode,
                                onDelete: () => _deleteExpense(ref, exp),
                                showDate: false,
                              );
                            },
                              childCount: recentThree.length,
                            ),
                          ),

                    // AI Insight Block
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                                      'AI Insight',
                                      style: AppTextStyles.captionBold(color: AppColors.getInfo(context)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      totalExpenses > totalBudgetLimit * 0.8
                                          ? 'You have spent ${(percent * 100).toStringAsFixed(0)}% of your monthly budget. Consider limiting non-essential shopping to avoid exceeding limits.'
                                          : 'Your monthly spending is well optimized. You have saved ${netSaved.toCurrencySymbol(currencyCode)}${netSaved.toStringAsFixed(0)} so far. Keep it up!',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // "+ Add Transaction" — Primary Button
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(shellTabIndexProvider.notifier).state = 1;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.getBrandPrimary(context),
                              foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 1,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.addTransaction,
                              style: AppTextStyles.headingSm(
                                color: isDark ? AppColors.brandFgDark : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 96)),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading budgets: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading expenses: $e')),
          ),
        ),
      ),
    );
  }
}
