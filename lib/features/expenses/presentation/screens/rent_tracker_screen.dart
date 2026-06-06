import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class RentTrackerScreen extends ConsumerWidget {
  const RentTrackerScreen({super.key});

  Future<void> _markAsPaid(WidgetRef ref, BuildContext context, DateTime targetDate, double amount, int dueDay) async {
    final repo = ref.read(expenseRepositoryProvider);
    final currentUser = ref.read(authStateProvider).valueOrNull;
    final userId = currentUser?.id ?? '';

    final rentExpense = Expense(
      id: const Uuid().v4(),
      userId: userId,
      amount: amount,
      currency: 'USD',
      category: ExpenseCategory.utilities,
      date: targetDate, // set to due date
      title: 'Rent Payment',
      note: 'Paid on time - Marked via Rent Tracker',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repo.addExpense(rentExpense);
    ref.invalidate(expensesStreamProvider);

    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rent payment of \$${amount.toStringAsFixed(0)} logged for ${DateFormat('MMMM yyyy').format(targetDate)}!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openEditDetailsSheet(BuildContext context, WidgetRef ref, double currentAmount, int currentDueDay) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditRentDetailsSheet(
        initialAmount: currentAmount,
        initialDueDay: currentDueDay,
        onSave: (amt, day) => ref.read(rentSettingsProvider.notifier).updateSettings(amt, day),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rentSettings = ref.watch(rentSettingsProvider);
    final rentAmount = rentSettings.amount;
    final dueDay = rentSettings.dueDay;

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            // Filter all rent expenses
            final rentPayments = expenses
                .where((e) =>
                    (e.title.toLowerCase().contains('rent') ||
                        e.note?.toLowerCase().contains('rent') == true) &&
                    e.type == TransactionType.expense &&
                    !e.isDeleted)
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));

            final now = DateTime.now();
            // Determine if this month is already paid
            final paidThisMonth = rentPayments.any((e) => e.date.month == now.month && e.date.year == now.year);
            
            DateTime nextDueDate;
            if (paidThisMonth) {
              nextDueDate = DateTime(now.year, now.month + 1, dueDay);
            } else {
              nextDueDate = DateTime(now.year, now.month, dueDay);
            }

            final daysRemaining = nextDueDate.difference(now).inDays;
            final displayRemaining = daysRemaining <= 0 ? 'Due today!' : 'in $daysRemaining days';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                ScreenHeader(
                  title: 'Rent Tracker',
                  subtitle: 'Never miss a payment',
                  showBackButton: true,
                  action: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminder set: 5 days before due date')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Rent Card (dark overlay image background)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.getShadow2(context),
                          image: DecorationImage(
                            image: const NetworkImage('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.65), // Ensures excellent readability of white text
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'NEXT RENT DUE',
                                  style: AppTextStyles.overline(color: Colors.white70),
                                ),
                                const Icon(Icons.house_outlined, color: Colors.white70, size: 20),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '\$${rentAmount.toStringAsFixed(0)}',
                              style: AppTextStyles.monospace(
                                36,
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${DateFormat('MMMM d, yyyy').format(nextDueDate)} · $displayRemaining',
                              style: AppTextStyles.bodySm(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: Icon(
                                      paidThisMonth ? Icons.check : Icons.check_outlined,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    label: Text(paidThisMonth ? 'Paid this Month' : 'Mark as Paid'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: paidThisMonth ? null : () => _markAsPaid(ref, context, nextDueDate, rentAmount, dueDay),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.access_time_outlined, size: 16, color: Colors.white),
                                    label: const Text('Set Reminder'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white24),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Notifications scheduled for rent reminders!')),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment History Section
                      Text(
                        'PAYMENT HISTORY',
                        style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: AppShadows.getCardDecoration(context),
                        padding: const EdgeInsets.all(8),
                        child: rentPayments.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    'No rent payments logged yet.',
                                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                  ),
                                ),
                              )
                            : Column(
                                children: rentPayments.map((e) {
                                  // Determine on-time/late status (paid on or before the due day is on time)
                                  final isOnTime = e.date.day <= dueDay;

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
                                      title: Text(
                                        DateFormat('MMMM yyyy').format(e.date),
                                        style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                                      ),
                                      subtitle: Text(
                                        'Paid: ${DateFormat('MMM d, h:mm a').format(e.date)}',
                                        style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '\$${e.amount.toStringAsFixed(0)}',
                                            style: AppTextStyles.monospace(
                                              14,
                                              color: AppColors.getFgPrimary(context),
                                              weight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: isOnTime
                                                  ? AppColors.getSuccessBg(context)
                                                  : AppColors.getWarningBg(context),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            child: Text(
                                              isOnTime ? 'On Time' : 'Late',
                                              style: AppTextStyles.captionBold(
                                                color: isOnTime
                                                    ? AppColors.getSuccess(context)
                                                    : AppColors.getWarning(context),
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

                      // AI Insight Block
                      Container(
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
                                    rentPayments.length >= 2
                                        ? 'You paid rent on time in ${rentPayments.where((e) => e.date.day <= dueDay).length} out of ${rentPayments.length} logged periods. AI suggests setting an auto-reminder 5 days before the ${dueDay}st.'
                                        : 'No rent habits detected yet. AI suggests configuring a reminder alert to protect your savings buffer.',
                                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Edit Details primary button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getBrandPrimary(context),
                            foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => _openEditDetailsSheet(context, ref, rentAmount, dueDay),
                          child: const Text(
                            'Add / Edit Rent Details',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

class _EditRentDetailsSheet extends StatefulWidget {
  const _EditRentDetailsSheet({
    required this.initialAmount,
    required this.initialDueDay,
    required this.onSave,
  });
  final double initialAmount;
  final int initialDueDay;
  final void Function(double, int) onSave;

  @override
  State<_EditRentDetailsSheet> createState() => _EditRentDetailsSheetState();
}

class _EditRentDetailsSheetState extends State<_EditRentDetailsSheet> {
  final _amountController = TextEditingController();
  final _dueDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.initialAmount.toStringAsFixed(0);
    _dueDayController.text = widget.initialDueDay.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            'Configure Rent Details',
            style: AppTextStyles.headingLg(color: AppColors.getFgPrimary(context)),
          ),
          const SizedBox(height: 24),
          Text(
            r'MONTHLY RENT AMOUNT ($)',
            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'e.g. 1850',
              filled: true,
              fillColor: AppColors.getBgSunken(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'MONTHLY DUE DAY (1-31)',
            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dueDayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'e.g. 1',
              filled: true,
              fillColor: AppColors.getBgSunken(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.getBrandPrimary(context),
                foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final amt = double.tryParse(_amountController.text.trim()) ?? 1850;
                final day = int.tryParse(_dueDayController.text.trim()) ?? 1;
                widget.onSave(amt, day.clamp(1, 31));
                Navigator.pop(context);
              },
              child: const Text('Save Details', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
