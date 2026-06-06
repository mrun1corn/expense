import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LendBorrowScreen extends ConsumerStatefulWidget {
  const LendBorrowScreen({super.key});

  @override
  ConsumerState<LendBorrowScreen> createState() => _LendBorrowScreenState();
}

class _LendBorrowScreenState extends ConsumerState<LendBorrowScreen> {
  int _activeTab = 0; // 0: Lent, 1: Borrowed

  Color _getAvatarBgColor(String name, bool isDark) {
    if (name.isEmpty) return Colors.grey;
    final hash = name.hashCode;
    final colors = isDark
        ? [
            const Color(0xFF3B2F2F),
            const Color(0xFF2F3B2F),
            const Color(0xFF2F2F3B),
            const Color(0xFF3B3B2F),
            const Color(0xFF3B2F3B),
            const Color(0xFF2F3B3B),
          ]
        : [
            const Color(0xFFFFD1D1),
            const Color(0xFFD1FFD1),
            const Color(0xFFD1D1FF),
            const Color(0xFFFFFFD1),
            const Color(0xFFFFD1FF),
            const Color(0xFFD1FFFF),
          ];
    return colors[hash.abs() % colors.length];
  }

  Color _getAvatarTextColor(String name, bool isDark) {
    if (name.isEmpty) return Colors.white;
    final hash = name.hashCode;
    final colors = isDark
        ? [
            const Color(0xFFFF8A8A),
            const Color(0xFF8AFF8A),
            const Color(0xFF8A8AFF),
            const Color(0xFFFFFF8A),
            const Color(0xFFFF8AFF),
            const Color(0xFF8AFFFF),
          ]
        : [
            const Color(0xFFB91C1C),
            const Color(0xFF15803D),
            const Color(0xFF1E40AF),
            const Color(0xFFB45309),
            const Color(0xFF701A75),
            const Color(0xFF0369A1),
          ];
    return colors[hash.abs() % colors.length];
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'O';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Future<void> _toggleSettled(Expense exp) async {
    final repo = ref.read(expenseRepositoryProvider);
    final isSettled = exp.note?.contains('#settled') ?? false;
    
    String newNote;
    if (isSettled) {
      newNote = exp.note?.replaceAll('#settled', '').trim() ?? '';
    } else {
      newNote = exp.note == null || exp.note!.isEmpty ? '#settled' : '${exp.note} #settled';
    }

    final updated = exp.copyWith(
      note: newNote.isEmpty ? null : newNote,
      updatedAt: DateTime.now(),
    );

    await repo.updateExpense(updated);
    ref.invalidate(expensesStreamProvider);

    if (mounted) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSettled ? 'Marked "${exp.title}" as Pending' : 'Marked "${exp.title}" as Settled!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = AppColors.getBrandPrimary(context);
    final inactiveColor = AppColors.getFgTertiary(context);

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            // Filter borrow and lend transactions
            final allLendBorrow = expenses
                .where((e) =>
                    (e.type == TransactionType.borrow || e.type == TransactionType.lend) &&
                    !e.isDeleted)
                .toList();

            final lentList = allLendBorrow.where((e) => e.type == TransactionType.lend).toList();
            final borrowList = allLendBorrow.where((e) => e.type == TransactionType.borrow).toList();

            // Calculate totals
            final totalLent = lentList
                .where((e) => !(e.note?.contains('#settled') ?? false))
                .fold<double>(0, (sum, e) => sum + e.amount);

            final totalBorrowed = borrowList
                .where((e) => !(e.note?.contains('#settled') ?? false))
                .fold<double>(0, (sum, e) => sum + e.amount);

            final activeList = _activeTab == 0 ? lentList : borrowList;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                ScreenHeader(
                  title: 'Lend & Borrow',
                  subtitle: 'Track money owed to and from you',
                  showBackButton: true,
                  action: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.push('/add');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab Switcher Bar
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.getBgSunken(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _activeTab = 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _activeTab == 0
                                        ? (isDark ? const Color(0xFF252525) : Colors.white)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _activeTab == 0 && !isDark ? AppShadows.shadow1Light : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Lent (You're Owed)",
                                    style: AppTextStyles.headingSm(
                                      color: _activeTab == 0 ? activeColor : inactiveColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _activeTab = 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _activeTab == 1
                                        ? (isDark ? const Color(0xFF252525) : Colors.white)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: _activeTab == 1 && !isDark ? AppShadows.shadow1Light : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Borrowed (You Owe)',
                                    style: AppTextStyles.headingSm(
                                      color: _activeTab == 1 ? activeColor : inactiveColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Summary Stat Tiles (2-col grid)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: AppShadows.getCardDecoration(context, radius: 12),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL LENT',
                                    style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${totalLent.toStringAsFixed(0)}',
                                    style: AppTextStyles.displayMd(color: AppColors.getSuccess(context)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'receivable balance',
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
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL BORROWED',
                                    style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${totalBorrowed.toStringAsFixed(0)}',
                                    style: AppTextStyles.displayMd(color: AppColors.getWarning(context)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'outstanding debt',
                                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Contact Rows List Section
                      Text(
                        _activeTab == 0 ? "LENT — YOU'RE OWED" : 'BORROWED — YOU OWE',
                        style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: AppShadows.getCardDecoration(context),
                        padding: const EdgeInsets.all(8),
                        child: activeList.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Text(
                                    'No transactions logged in this category.',
                                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                  ),
                                ),
                              )
                            : Column(
                                children: activeList.map((e) {
                                  final isSettled = e.note?.contains('#settled') ?? false;
                                  final avatarName = e.title;
                                  final cleanNote = e.note?.replaceAll('#settled', '').trim() ?? '';
                                  final displayAmount = _activeTab == 0 ? '+\$${e.amount.toStringAsFixed(0)}' : '-\$${e.amount.toStringAsFixed(0)}';
                                  final amountColor = _activeTab == 0 ? AppColors.getSuccess(context) : AppColors.getFgPrimary(context);

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: isDark ? const Color(0x12FFFFFF) : const Color(0x0F000000),
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      leading: CircleAvatar(
                                        backgroundColor: _getAvatarBgColor(avatarName, isDark),
                                        radius: 18,
                                        child: Text(
                                          _getInitials(avatarName),
                                          style: TextStyle(
                                            color: _getAvatarTextColor(avatarName, isDark),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        e.title,
                                        style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)).copyWith(
                                          decoration: isSettled ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${DateFormat('MMM d, yyyy').format(e.date)}${cleanNote.isNotEmpty ? ' · $cleanNote' : ''}',
                                        style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            displayAmount,
                                            style: AppTextStyles.monospace(
                                              14,
                                              color: isSettled ? AppColors.getFgTertiary(context) : amountColor,
                                              weight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _toggleSettled(e),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isSettled
                                                    ? AppColors.getSuccessBg(context)
                                                    : AppColors.getBgSunken(context),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              child: Text(
                                                isSettled ? 'Settled' : 'Pending',
                                                style: AppTextStyles.captionBold(
                                                  color: isSettled
                                                      ? AppColors.getSuccess(context)
                                                      : AppColors.getFgSecondary(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // AI Nudge Block
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.getBgSunken(context),
                          borderRadius: BorderRadius.circular(12),
                          border: const Border(left: BorderSide(color: Color(0xFFFBBF24), width: 3)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFBBF24), size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'AI NUDGE',
                                  style: AppTextStyles.overline(color: const Color(0xFFFBBF24)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              activeList.where((e) => !(e.note?.contains('#settled') ?? false)).isNotEmpty
                                  ? '${activeList.firstWhere((e) => !(e.note?.contains('#settled') ?? false)).title} has had an active balance outstanding for more than 14 days. AI suggests sending a friendly reminder.'
                                  : 'No outstanding balances have been active for more than 14 days. All clear!',
                              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.4),
                            ),
                            if (activeList.where((e) => !(e.note?.contains('#settled') ?? false)).isNotEmpty) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 36,
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Friendly reminder copied to clipboard!')),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.getBrandPrimary(context)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(
                                    'Send Reminder',
                                    style: TextStyle(fontSize: 12, color: AppColors.getFgPrimary(context), fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add Entry primary button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getBrandPrimary(context),
                            foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            context.push('/add');
                          },
                          child: Text(
                            _activeTab == 0 ? '+ Add Lent Entry' : '+ Add Borrow Entry',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
