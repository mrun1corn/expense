import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

enum TransactionType {
  expense,
  income,
  borrow,
  lend,
}

enum ExpenseCategory {
  // Expense
  food,
  transport,
  utilities,
  entertainment,
  shopping,
  health,
  education,
  
  // Income
  salary,
  business,
  investment,
  gift,
  
  // Borrow / Lend
  friend,
  bank,
  family,
  
  // Fallback
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
    required DateTime createdAt,
    required DateTime updatedAt,
    String? paymentSystem,
    String? note,
    String? receiptImageUrl,
    @Default(TransactionType.expense) TransactionType type,
    @Default(false) bool isSynced,
    @Default(false) bool isDeleted,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
