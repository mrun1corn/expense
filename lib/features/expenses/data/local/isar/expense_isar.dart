import 'package:isar/isar.dart';
import '../../../../domain/models/expense.dart';

part 'expense_isar.g.dart';

@collection
class ExpenseIsar {
  Id isarId = Isar.autoIncrement; // Auto-increment integer ID required by Isar

  @Index(unique: true, replace: true)
  late String id; // UUID string

  late String userId;
  late double amount;
  late String currency;
  late String category; // Store as string for flexibility

  late DateTime date;
  late String title;
  String? note;
  String? receiptImageUrl;
  late bool isSynced;
  late DateTime createdAt;
  late DateTime updatedAt;

  // Converts from Isar model to Domain model
  Expense toDomain() {
    return Expense(
      id: id,
      userId: userId,
      amount: amount,
      currency: currency,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ExpenseCategory.other,
      ),
      date: date,
      title: title,
      note: note,
      receiptImageUrl: receiptImageUrl,
      isSynced: isSynced,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Converts from Domain model to Isar model
  static ExpenseIsar fromDomain(Expense expense) {
    return ExpenseIsar()
      ..id = expense.id
      ..userId = expense.userId
      ..amount = expense.amount
      ..currency = expense.currency
      ..category = expense.category.name
      ..date = expense.date
      ..title = expense.title
      ..note = expense.note
      ..receiptImageUrl = expense.receiptImageUrl
      ..isSynced = expense.isSynced
      ..createdAt = expense.createdAt
      ..updatedAt = expense.updatedAt;
  }
}
