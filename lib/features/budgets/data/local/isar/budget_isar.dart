import 'package:isar/isar.dart';
import '../../../../domain/models/budget.dart';
import '../../../expenses/domain/models/expense.dart';

part 'budget_isar.g.dart';

@collection
class BudgetIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String userId;
  late String category; // Store as string
  late double limitAmount;
  late String currency;
  late int month;
  late int year;
  late double spentAmount;
  late DateTime createdAt;

  Budget toDomain() {
    return Budget(
      id: id,
      userId: userId,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ExpenseCategory.other,
      ),
      limitAmount: limitAmount,
      currency: currency,
      month: month,
      year: year,
      spentAmount: spentAmount,
      createdAt: createdAt,
    );
  }

  static BudgetIsar fromDomain(Budget budget) {
    return BudgetIsar()
      ..id = budget.id
      ..userId = budget.userId
      ..category = budget.category.name
      ..limitAmount = budget.limitAmount
      ..currency = budget.currency
      ..month = budget.month
      ..year = budget.year
      ..spentAmount = budget.spentAmount
      ..createdAt = budget.createdAt;
  }
}
