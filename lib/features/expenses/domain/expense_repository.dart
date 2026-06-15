import 'package:expense/features/expenses/domain/models/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses();
  Stream<List<Expense>> watchExpensesByMonth(int year, int month);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<List<Expense>> getExpensesByMonth(int month, int year);
  Future<List<Expense>> getLast60DaysExpenses();
  Future<Map<ExpenseCategory, double>> getCategoryTotals(
    DateTime from,
    DateTime to,
  );
}
