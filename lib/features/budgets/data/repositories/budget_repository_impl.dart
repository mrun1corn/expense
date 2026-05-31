import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/budgets/data/local/isar/budget_isar.dart';
import 'package:expense/features/budgets/domain/models/budget.dart';
import 'package:expense/features/budgets/domain/repositories/budget_repository.dart';
import 'package:isar/isar.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final Isar _isar = IsarService.instance.isar;

  @override
  Future<List<Budget>> getBudgets(int month, int year) async {
    final list = await _isar.budgetIsars
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findAll();
    return list.map((e) => e.toDomain()).toList();
  }

  @override
  Stream<List<Budget>> watchBudgets(int month, int year) {
    return _isar.budgetIsars
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .watch(fireImmediately: true)
        .map((list) => list.map((e) => e.toDomain()).toList());
  }

  @override
  Future<void> saveBudget(Budget budget) async {
    final isarObj = BudgetIsar.fromDomain(budget);
    final existing = await _isar.budgetIsars
        .filter()
        .idEqualTo(budget.id)
        .findFirst();
    if (existing != null) {
      isarObj.isarId = existing.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.budgetIsars.put(isarObj);
    });
  }

  @override
  Future<void> deleteBudget(String id) async {
    final existing = await _isar.budgetIsars
        .filter()
        .idEqualTo(id)
        .findFirst();
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.budgetIsars.delete(existing.isarId);
      });
    }
  }
}
