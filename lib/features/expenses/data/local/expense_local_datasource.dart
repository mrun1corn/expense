import 'package:expense/features/expenses/data/local/isar/expense_isar.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:isar/isar.dart';

class ExpenseLocalDatasource {

  ExpenseLocalDatasource(this._isar);
  final Isar _isar;

  // Watches all expenses sorted by date descending in real-time
  Stream<List<Expense>> watchAll() {
    return _isar.expenseIsars
        .filter()
        .isDeletedEqualTo(false)
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((list) => list.map<Expense>((e) => e.toDomain()).toList());
  }
  // Watches expenses for a specific month
  Stream<List<Expense>> watchByMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);
    return _isar.expenseIsars
        .filter()
        .isDeletedEqualTo(false)
        .dateBetween(start, end)
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((list) => list.map<Expense>((e) => e.toDomain()).toList());
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

  // Deletes an expense by its UUID id (Soft-delete!)
  Future<void> delete(String id) async {
    final existing = await _isar.expenseIsars
        .filter()
        .idEqualTo(id)
        .findFirst();
    if (existing != null) {
      final updated = existing.toDomain().copyWith(
        isDeleted: true,
        isSynced: false,
        updatedAt: DateTime.now(),
      );
      final expenseIsar = ExpenseIsar.fromDomain(updated)..isarId = existing.isarId;
      await _isar.writeTxn(() async {
        await _isar.expenseIsars.put(expenseIsar);
      });
    }
  }

  // Fetches expenses within a specific calendar month and year
  Future<List<Expense>> getByMonth(int month, int year) async {
    final start = DateTime(year, month);
    final end = DateTime(
      year,
      month + 1,
    ).subtract(const Duration(milliseconds: 1));
    final results = await _isar.expenseIsars
        .filter()
        .isDeletedEqualTo(false)
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
    return results.map<Expense>((e) => e.toDomain()).toList();
  }

  // Fetches last 60 days of expenses, sorted by date descending (for PatternDetector)
  Future<List<Expense>> getLast60Days() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 60));
    final results = await _isar.expenseIsars
        .filter()
        .isDeletedEqualTo(false)
        .dateGreaterThan(cutoff)
        .sortByDateDesc()
        .findAll();
    return results.map<Expense>((e) => e.toDomain()).toList();
  }

  // Fetches all unsynced expenses
  Future<List<Expense>> getUnsyncedExpenses() async {
    final results = await _isar.expenseIsars
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
    return results.map<Expense>((e) => e.toDomain()).toList();
  }

  // Fetches the most recently updated expense
  Future<Expense?> getLatestExpense() async {
    final result = await _isar.expenseIsars
        .filter()
        .isDeletedEqualTo(false)
        .sortByUpdatedAtDesc()
        .findFirst();
    return result?.toDomain();
  }

  // Saves a batch of expenses (LWW implementation)
  Future<void> saveExpenses(List<Expense> expenses) async {
    await _isar.writeTxn(() async {
      for (final e in expenses) {
        final existing = await _isar.expenseIsars
            .filter()
            .idEqualTo(e.id)
            .findFirst();
        
        if (existing != null) {
          // LWW Check: Do not overwrite if local record is newer
          if (e.updatedAt.isBefore(existing.updatedAt)) {
            continue;
          }
        }
        
        final isarObj = ExpenseIsar.fromDomain(e);
        if (existing != null) {
          isarObj.isarId = existing.isarId;
        }
        await _isar.expenseIsars.put(isarObj);
      }
    });
  }

  // Purges successfully synced soft-deleted records, and marks others as synced
  Future<void> purgeDeletedAndMarkSynced(List<Expense> expenses) async {
    await _isar.writeTxn(() async {
      for (final e in expenses) {
        final existing = await _isar.expenseIsars
            .filter()
            .idEqualTo(e.id)
            .findFirst();
        if (existing != null) {
          if (e.isDeleted) {
            await _isar.expenseIsars.delete(existing.isarId); // Purge!
          } else {
            final updated = existing.toDomain().copyWith(isSynced: true);
            final isarObj = ExpenseIsar.fromDomain(updated)..isarId = existing.isarId;
            await _isar.expenseIsars.put(isarObj); // Mark synced
          }
        }
      }
    });
  }

  // Reconciles synced expenses by deleting local records that are no longer present on remote
  Future<void> reconcileSyncedExpenses(String userId, List<String> remoteIds) async {
    if (userId.isEmpty) return;
    
    await _isar.writeTxn(() async {
      // Find all local expenses for this user that are marked synced
      final localSynced = await _isar.expenseIsars
          .filter()
          .userIdEqualTo(userId)
          .isSyncedEqualTo(true)
          .findAll();
          
      final remoteIdsSet = remoteIds.toSet();
      final toDelete = <int>[];
      
      for (final local in localSynced) {
        if (!remoteIdsSet.contains(local.id)) {
          toDelete.add(local.isarId);
        }
      }
      
      if (toDelete.isNotEmpty) {
        await _isar.expenseIsars.deleteAll(toDelete);
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
        .isDeletedEqualTo(false)
        .dateBetween(from, to)
        .findAll();

    final totals = <ExpenseCategory, double>{};
    for (final exp in results) {
      final domainExp = exp.toDomain();
      totals[domainExp.category] =
          (totals[domainExp.category] ?? 0.0) + domainExp.amount;
    }
    return totals;
  }
}
