import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/core/payment/payment_systems_manager.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

  // Visual icons for categories
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

  Widget _buildPaymentSystemBadge(BuildContext context, String systemName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = PaymentSystemsManager.getSystemTypeColor(systemName);

    Color bg;
    Color fg;

    switch (type) {
      case 'mfs':
        bg = isDark ? const Color(0xFF085041) : const Color(0xFFE1F5EE);
        fg = isDark ? const Color(0xFF9FE1CB) : const Color(0xFF0F6E56);
        break;
      case 'rtp':
        bg = isDark ? const Color(0xFF0C447C) : const Color(0xFFE6F1FB);
        fg = isDark ? const Color(0xFFB5D4F4) : const Color(0xFF185FA5);
        break;
      case 'wallet':
        bg = isDark ? const Color(0xFF3C3489) : const Color(0xFFEEEDFE);
        fg = isDark ? const Color(0xFFCECBF6) : const Color(0xFF534AB7);
        break;
      case 'bank':
        bg = isDark ? const Color(0xFF633806) : const Color(0xFFFAEEDA);
        fg = isDark ? const Color(0xFFFAC775) : const Color(0xFF854F0B);
        break;
      case 'neo':
        bg = isDark ? const Color(0xFF712B13) : const Color(0xFFFAECE7);
        fg = isDark ? const Color(0xFFF5C4B3) : const Color(0xFF993C1D);
        break;
      case 'card':
        bg = isDark ? const Color(0xFF27500A) : const Color(0xFFEAF3DE);
        fg = isDark ? const Color(0xFFC0DD97) : const Color(0xFF3B6D11);
        break;
      case 'cbdc':
        bg = isDark ? const Color(0xFF72243E) : const Color(0xFFFBEAF0);
        fg = isDark ? const Color(0xFFF4C0D1) : const Color(0xFF993556);
        break;
      default:
        bg = isDark ? const Color(0xFF444441) : const Color(0xFFF1EFE8);
        fg = isDark ? const Color(0xFFD3D1C7) : const Color(0xFF5F5E5A);
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        systemName,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

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

    final expensesAsync = ref.watch(expensesStreamProvider);
    final budgetsAsync = ref.watch(budgetsStreamProvider(_selectedMonth));
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final userName = currentUser?.displayName ?? 'Alex';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rentSettings = ref.watch(rentSettingsProvider);
    final rentAmount = rentSettings.amount;
    final dueDay = rentSettings.dueDay;
    final currencyCode = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(expensesStreamProvider)
              ..invalidate(budgetsStreamProvider(_selectedMonth));
          },
          child: expensesAsync.when(
            data: (expenses) => budgetsAsync.when(
              data: (budgets) {
                // Filter this month's expenses
                final thisMonthExpenses = expenses.where((e) =>
                    e.date.month == _selectedMonth.month &&
                    e.date.year == _selectedMonth.year &&
                    !e.isDeleted).toList();

                final rentPayments = expenses
                    .where((e) =>
                        (e.title.toLowerCase().contains('rent') ||
                            e.note?.toLowerCase().contains('rent') == true) &&
                        e.type == TransactionType.expense &&
                        !e.isDeleted)
                    .toList();
                
                final now = DateTime.now();
                final paidThisMonth = rentPayments.any((e) => e.date.month == now.month && e.date.year == now.year);
                
                DateTime nextDueDate;
                if (paidThisMonth) {
                  nextDueDate = DateTime(now.year, now.month + 1, dueDay);
                } else {
                  nextDueDate = DateTime(now.year, now.month, dueDay);
                }

                final daysRemaining = nextDueDate.difference(now).inDays;
                final displayRemaining = daysRemaining <= 0 ? 'Due today' : '$daysRemaining days';
                final displaySub = '${DateFormat('MMM d').format(nextDueDate)} - ${rentAmount.toCurrencySymbol(currencyCode)}${rentAmount.toStringAsFixed(0)}';

                final totalIncome = thisMonthExpenses
                    .where((e) => e.type == TransactionType.income)
                    .fold<double>(0, (sum, e) => sum + e.amount);

                final totalExpenses = thisMonthExpenses
                    .where((e) => e.type == TransactionType.expense)
                    .fold<double>(0, (sum, e) => sum + e.amount);

                final netSaved = totalIncome - totalExpenses;

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
                final lastMonthDate = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                final lastMonthExpensesList = expenses.where((e) =>
                    e.date.month == lastMonthDate.month &&
                    e.date.year == lastMonthDate.year &&
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
                        overline: 'GOOD MORNING, ${userName.toUpperCase()}',
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
                        child: Row(
                          children: [
                            Expanded(
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
                                          AppLocalizations.of(context)!.saved.toUpperCase(),
                                          style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                        ),
                                        Icon(Icons.savings_outlined, size: 16, color: AppColors.getFgTertiary(context)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${netSaved.toCurrencySymbol(currencyCode)}${netSaved.toStringAsFixed(0)}',
                                      style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'vs last month',
                                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.push('/rent-tracker'),
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
                                            AppLocalizations.of(context)!.rentDue.toUpperCase(),
                                            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                          ),
                                          Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.getFgTertiary(context)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        displayRemaining,
                                        style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$displaySub · Manage',
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
                            GestureDetector(
                              onTap: () => context.push('/budgets'),
                              child: Text(
                                'Manage Budgets',
                                style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(
                                  decoration: TextDecoration.underline,
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
                                final catColor = _getCategoryColor(cat);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Icon(_getCategoryIcon(cat), size: 14, color: catColor),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          _formatEnumName(cat.name),
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
                            GestureDetector(
                              onTap: () {
                                // Clear filter or go to insights
                              },
                              child: Text(
                                'See All',
                                style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(
                                  decoration: TextDecoration.underline,
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
                                final isExpense = exp.type == TransactionType.expense;
                                final isIncome = exp.type == TransactionType.income;
                                final symbol = 0.0.toCurrencySymbol(currencyCode);
                                final prefix = isIncome ? '+$symbol' : (isExpense ? '-$symbol' : symbol);
                                final amountColor = isIncome
                                    ? AppColors.getSuccess(context)
                                    : (isExpense ? AppColors.getFgPrimary(context) : AppColors.getBrandPrimary(context));

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                  child: Container(
                                    decoration: AppShadows.getCardDecoration(context, radius: 12),
                                    child: Slidable(
                                      key: ValueKey(exp.id),
                                      endActionPane: ActionPane(
                                        motion: const BehindMotion(),
                                        dismissible: DismissiblePane(
                                          onDismissed: () => _deleteExpense(ref, exp),
                                        ),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) => _deleteExpense(ref, exp),
                                            backgroundColor: AppColors.dangerLight,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.getBgSunken(context),
                                          radius: 18,
                                          child: Icon(
                                            _getCategoryIcon(exp.category),
                                            color: _getCategoryColor(exp.category),
                                            size: 18,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                exp.title,
                                                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (exp.paymentSystem != null) ...[
                                              const SizedBox(width: 8),
                                              _buildPaymentSystemBadge(context, exp.paymentSystem!),
                                            ],
                                          ],
                                        ),
                                        subtitle: Text(
                                          '${_formatEnumName(exp.category.name)} · ${DateFormat('h:mm a').format(exp.date)}',
                                          style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                        ),
                                        trailing: Text(
                                          '$prefix${exp.amount.toStringAsFixed(2)}',
                                          style: AppTextStyles.monospace(
                                            14,
                                            color: amountColor,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                        onTap: () {
                                          context.push('/expense/${exp.id}', extra: exp);
                                        },
                                      ),
                                    ),
                                  ),
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
