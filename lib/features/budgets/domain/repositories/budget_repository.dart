import 'package:expense/features/budgets/domain/models/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets(int month, int year);
  Stream<List<Budget>> watchBudgets(int month, int year);
  Future<void> saveBudget(Budget budget);
  Future<void> deleteBudget(String id);
}
