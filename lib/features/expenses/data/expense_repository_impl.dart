import 'package:expense/features/expenses/data/local/expense_local_datasource.dart';
import 'package:expense/features/expenses/domain/expense_repository.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  ExpenseRepositoryImpl(this._localDatasource);
  final ExpenseLocalDatasource _localDatasource;

  @override
  Stream<List<Expense>> watchExpenses() {
    return _localDatasource.watchAll();
  }
  @override
  Stream<List<Expense>> watchExpensesByMonth(int year, int month) {
    return _localDatasource.watchByMonth(year, month);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    final e = expense.copyWith(isSynced: false, updatedAt: DateTime.now());
    await _localDatasource.add(e);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final e = expense.copyWith(isSynced: false, updatedAt: DateTime.now());
    await _localDatasource.update(e);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _localDatasource.delete(id);
  }

  @override
  Future<List<Expense>> getExpensesByMonth(int month, int year) {
    return _localDatasource.getByMonth(month, year);
  }

  @override
  Future<List<Expense>> getLast60DaysExpenses() {
    return _localDatasource.getLast60Days();
  }

  @override
  Future<Map<ExpenseCategory, double>> getCategoryTotals(
    DateTime from,
    DateTime to,
  ) {
    return _localDatasource.getCategoryTotals(from, to);
  }
}
