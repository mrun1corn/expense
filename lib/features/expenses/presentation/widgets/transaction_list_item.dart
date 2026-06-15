import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/core/extensions/double_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:expense/l10n/app_localizations.dart';
import 'package:expense/features/expenses/presentation/widgets/expense_ui_utils.dart';

class TransactionListItem extends ConsumerWidget {
  const TransactionListItem({
    super.key,
    required this.expense,
    required this.currencyCode,
    required this.onDelete,
    this.showDate = false,
  });

  final Expense expense;
  final String currencyCode;
  final VoidCallback onDelete;
  final bool showDate;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpense = expense.type == TransactionType.expense;
    final isIncome = expense.type == TransactionType.income;
    final symbol = 0.0.toCurrencySymbol(currencyCode);
    final prefix = isIncome ? '+$symbol' : (isExpense ? '-$symbol' : symbol);
    final amountColor = isIncome
        ? AppColors.getSuccess(context)
        : (isExpense ? AppColors.getFgPrimary(context) : AppColors.getBrandPrimary(context));

    final timeString = DateFormat('h:mm a').format(expense.date);
    final dateString = DateFormat('MMM d').format(expense.date);
    final subtitleStr = showDate 
        ? '${ExpenseUiUtils.formatEnumName(expense.category.name)} · $dateString, $timeString'
        : '${ExpenseUiUtils.formatEnumName(expense.category.name)} · $timeString';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: AppShadows.getCardDecoration(context, radius: 12),
        child: Slidable(
          key: ValueKey(expense.id),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            dismissible: DismissiblePane(onDismissed: onDelete),
            children: [
              SlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: AppColors.dangerLight,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: AppLocalizations.of(context)?.deleted ?? 'Delete',
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: AppColors.getBgSunken(context),
              radius: 18,
              child: Icon(
                ExpenseUiUtils.getCategoryIcon(expense.category),
                color: ExpenseUiUtils.getCategoryColor(expense.category),
                size: 18,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    expense.title,
                    style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (expense.paymentSystem != null) ...[
                  const SizedBox(width: 8),
                  _buildPaymentSystemBadge(context, expense.paymentSystem!),
                ],
              ],
            ),
            subtitle: Text(
              subtitleStr,
              style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
            ),
            trailing: Text(
              '$prefix${expense.amount.toStringAsFixed(2)}',
              style: AppTextStyles.monospace(
                14,
                color: amountColor,
                weight: FontWeight.w600,
              ),
            ),
            onTap: () {
              context.push('/expense/${expense.id}', extra: expense);
            },
          ),
        ),
      ),
    );
  }
}
