import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

enum ExpenseCategory {
  food,
  transport,
  utilities,
  entertainment,
  shopping,
  health,
  education,
  other,
}

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id, // UUID
    required String userId, // empty string for guest
    required double amount,
    required String currency,
    required ExpenseCategory category,
    required DateTime date, // full timestamp (date + time)
    required String title,
    String? note,
    String? receiptImageUrl,
    @Default(false) bool isSynced,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
