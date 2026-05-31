import 'package:isar/isar.dart';
import '../../domain/models/expense.dart';
import 'isar/expense_isar.dart';

class ExpenseLocalDatasource {
  final Isar _isar;

  ExpenseLocalDatasource(this._isar);

  // Watches all expenses sorted by date descending in real-time
  Stream<List<Expense>> watchAll() {
    return _isar.expenseIsars
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  // Adds a new expense to Isar database
  Future<void> add(Expense e) async {
    final expenseIsar = ExpenseIsar.fromDomain(e);
    await _isar.writeTxn(() async {
      await _isar.expenseIsars.put(expenseIsar);
    });
  }

  // Updates an existing expense
  Future<void> update(Expense e) async {
    final existing = await _isar.expenseIsars
        .filter()
        .idEqualTo(e.id)
        .findFirst();
    if (existing != null) {
      final expenseIsar = ExpenseIsar.fromDomain(e)..isarId = existing.isarId;
      await _isar.writeTxn(() async {
        await _isar.expenseIsars.put(expenseIsar);
      });
    }
  }

  // Deletes an expense by its UUID id
  Future<void> delete(String id) async {
    final existing = await _isar.expenseIsars
        .filter()
        .idEqualTo(id)
        .findFirst();
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.expenseIsars.delete(existing.isarId);
      });
    }
  }

  // Fetches expenses within a specific calendar month and year
  Future<List<Expense>> getByMonth(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(
      year,
      month + 1,
      1,
    ).subtract(const Duration(milliseconds: 1));
    final results = await _isar.expenseIsars
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
    return results.map((e) => e.toDomain()).toList();
  }

  // Fetches last 60 days of expenses, sorted by date descending (for PatternDetector)
  Future<List<Expense>> getLast60Days() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 60));
    final results = await _isar.expenseIsars
        .filter()
        .dateGreaterThan(cutoff)
        .sortByDateDesc()
        .findAll();
    return results.map((e) => e.toDomain()).toList();
  }

  // Fetches all unsynced expenses
  Future<List<Expense>> getUnsyncedExpenses() async {
    final results = await _isar.expenseIsars
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
    return results.map((e) => e.toDomain()).toList();
  }

  // Fetches the most recently updated expense
  Future<Expense?> getLatestExpense() async {
    final result = await _isar.expenseIsars
        .where()
        .sortByUpdatedAtDesc()
        .findFirst();
    return result?.toDomain();
  }

  // Saves a batch of expenses
  Future<void> saveExpenses(List<Expense> expenses) async {
    await _isar.writeTxn(() async {
      for (final e in expenses) {
        final existing = await _isar.expenseIsars
            .filter()
            .idEqualTo(e.id)
            .findFirst();
        final isarObj = ExpenseIsar.fromDomain(e);
        if (existing != null) {
          isarObj.isarId = existing.isarId;
        }
        await _isar.expenseIsars.put(isarObj);
      }
    });
  }

  // Computes category spending totals within a time range
  Future<Map<ExpenseCategory, double>> getCategoryTotals(
    DateTime from,
    DateTime to,
  ) async {
    final results = await _isar.expenseIsars
        .filter()
        .dateBetween(from, to)
        .findAll();

    final Map<ExpenseCategory, double> totals = {};
    for (final exp in results) {
      final domainExp = exp.toDomain();
      totals[domainExp.category] =
          (totals[domainExp.category] ?? 0.0) + domainExp.amount;
    }
    return totals;
  }
}
