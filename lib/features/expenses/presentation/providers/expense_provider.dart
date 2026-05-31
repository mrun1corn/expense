import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/expenses/data/expense_repository_impl.dart';
import 'package:expense/features/expenses/data/local/expense_local_datasource.dart';
import 'package:expense/features/expenses/domain/expense_repository.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// Provides the Isar instance
final Provider<Isar> isarProvider = Provider((ref) {
  return IsarService.instance.isar;
});

// Provides the local datasource
final Provider<ExpenseLocalDatasource> expenseLocalDatasourceProvider = Provider((ref) {
  final isar = ref.watch(isarProvider);
  return ExpenseLocalDatasource(isar);
});

// Provides the repository
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final localDatasource = ref.watch(expenseLocalDatasourceProvider);
  return ExpenseRepositoryImpl(localDatasource);
});

// Real-time stream of all expenses
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchExpenses();
});

// Provides expenses for a specific month and year
final FutureProviderFamily<List<Expense>, ({int month, int year})> monthlyExpensesProvider =
    FutureProvider.family<List<Expense>, ({int month, int year})>((ref, arg) {
      final repository = ref.watch(expenseRepositoryProvider);
      return repository.getExpensesByMonth(arg.month, arg.year);
    });

// Provides category totals for a date range
final FutureProviderFamily<Map<ExpenseCategory, double>, ({DateTime from, DateTime to})> categoryTotalsProvider =
    FutureProvider.family<
      Map<ExpenseCategory, double>,
      ({DateTime from, DateTime to})
    >((ref, arg) {
      final repository = ref.watch(expenseRepositoryProvider);
      return repository.getCategoryTotals(arg.from, arg.to);
    });

// Provides the total amount spent in the current month
final totalThisMonthProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(expensesStreamProvider).whenData((list) {
    final now = DateTime.now();
    return list
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0, (sum, item) => sum + item.amount);
  });
});

// Provides the last 60 days of expenses (mainly for pattern engine)
final last60DaysProvider = FutureProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getLast60DaysExpenses();
});
