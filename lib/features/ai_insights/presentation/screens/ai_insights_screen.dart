import 'dart:convert';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/ai_insights/presentation/providers/gemini_provider.dart';
import 'package:expense/features/ai_insights/presentation/screens/ai_auth_fallback.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final AutoDisposeFutureProvider<String> monthlySummaryProvider = FutureProvider.autoDispose<String>((ref) async {
  final expenses = await ref.watch(last60DaysProvider.future);
  
  if (expenses.isEmpty) {
    return 'Not enough data this month to generate an AI summary.';
  }

  final now = DateTime.now();
  final thisMonth = expenses.where((e) => e.date.month == now.month && e.date.year == now.year && !e.isDeleted).toList();
  
  if (thisMonth.isEmpty) {
    return 'You have no recorded spending this month. Start tracking to get insights!';
  }

  final summaryJson = jsonEncode(thisMonth.map((e) => {
    'title': e.title,
    'amount': e.amount,
    'category': e.category.name,
    'date': e.date.toIso8601String(),
  }).toList());

  final gemini = ref.watch(geminiDatasourceProvider);
  return gemini.generateMonthlySummary(summaryJson);
});

class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final hasApiKey = ref.watch(apiKeyProvider).isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!hasApiKey) {
      return Scaffold(
        backgroundColor: AppColors.getBgBase(context),
        appBar: AppBar(
          title: const Text('AI Insights'),
        ),
        body: const SafeArea(
          child: AiAuthFallback(
            title: 'Unlock AI Insights',
            subtitle: 'Get automatically generated monthly spending summaries, categorization alerts, and budget advice powered by Gemini.',
          ),
        ),
      );
    }

    final summaryAsync = ref.watch(monthlySummaryProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            final now = DateTime.now();
            final thisMonthExpenses = expenses
                .where((e) => e.date.month == now.month && e.date.year == now.year && !e.isDeleted)
                .toList();

            final totalExpenses = thisMonthExpenses
                .where((e) => e.type == TransactionType.expense)
                .fold<double>(0, (sum, e) => sum + e.amount);

            final totalIncome = thisMonthExpenses
                .where((e) => e.type == TransactionType.income)
                .fold<double>(0, (sum, e) => sum + e.amount);

            final savedAmount = (totalIncome - totalExpenses).clamp(0, double.infinity);

            // Group category spending
            final spentByCategory = <ExpenseCategory, double>{};
            for (final exp in thisMonthExpenses) {
              if (exp.type == TransactionType.expense) {
                spentByCategory[exp.category] = (spentByCategory[exp.category] ?? 0.0) + exp.amount;
              }
            }

            final sortedCategories = spentByCategory.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                ScreenHeader(
                  title: 'AI Insights',
                  subtitle: 'Your smart spending summary',
                  action: IconButton(
                    icon: const Icon(Icons.notifications_none_outlined),
                    onPressed: () => context.push('/settings/notifications'),
                  ),
                ),
                const SizedBox(height: 12),
                // June Recap Card (hero/dark)
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
                        '${DateFormat('MMMM').format(now).toUpperCase()} RECAP',
                        style: AppTextStyles.overline(
                          color: AppColors.getHeroFgMuted(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      summaryAsync.when(
                        data: (summary) => Text(
                          summary,
                          style: AppTextStyles.bodyMd(
                            color: AppColors.getHeroFg(context),
                          ).copyWith(height: 1.5),
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                                SizedBox(height: 12),
                                Text(
                                  'Gemini is generating recap summary...',
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        error: (err, _) => Text(
                          'Could not generate recap: $err',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row (2 columns)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: AppShadows.getCardDecoration(context, radius: 12),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL SPENT',
                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${totalExpenses.toStringAsFixed(0)}',
                              style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'this month',
                              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: AppShadows.getCardDecoration(context, radius: 12),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SAVED',
                              style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${savedAmount.toStringAsFixed(0)}',
                              style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'net savings',
                              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Spending Breakdown section
                Text(
                  'SPENDING BREAKDOWN',
                  style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: AppShadows.getCardDecoration(context),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: sortedCategories.isEmpty
                        ? [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'No category spending data yet.',
                                style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                              ),
                            )
                          ]
                          : sortedCategories.map((entry) {
                              final cat = entry.key;
                              final spent = entry.value;
                              final pct = totalExpenses > 0 ? (spent / totalExpenses) : 0.0;
                              final color = _getCategoryColor(cat);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Icon(_getCategoryIcon(cat), size: 14, color: color),
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
                                            value: pct,
                                            backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              isDark ? Colors.white : AppColors.getBrandPrimary(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 32,
                                      child: Text(
                                        '${(pct * 100).toStringAsFixed(0)}%',
                                        textAlign: TextAlign.right,
                                        style: AppTextStyles.captionBold(
                                          color: AppColors.getFgSecondary(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // AI Trends & Tips
                Text(
                  'AI TRENDS & TIPS',
                  style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                ),
                const SizedBox(height: 12),
                _buildTipTile(
                  context,
                  icon: Icons.lightbulb_outline,
                  color: AppColors.getWarning(context),
                  text: r'Your food expenditure is 15% higher than last week. Cooking at home two more days could save you up to $45.',
                ),
                const SizedBox(height: 10),
                _buildTipTile(
                  context,
                  icon: Icons.trending_down,
                  color: AppColors.getSuccess(context),
                  text: 'Great work! You have lowered your entertainment costs by 8% this month, keeping your overall budget safe.',
                ),
                const SizedBox(height: 24),

                // Ask AI Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text(
                      'Ask AI a Question',
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
                const SizedBox(height: 96),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading insights: $e')),
        ),
      ),
    );
  }

  Widget _buildTipTile(BuildContext context, {required IconData icon, required Color color, required String text}) {
    return Container(
      decoration: AppShadows.getCardDecoration(context, radius: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            radius: 16,
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
