import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,
    required ExpenseCategory category,
    required double limitAmount,
    required String currency,
    required int month,
    required int year,
    required DateTime createdAt, @Default(0.0) double spentAmount,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
