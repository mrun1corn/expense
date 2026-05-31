import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/expense.dart';
import '../../domain/expense_repository.dart';
import '../../data/expense_repository_impl.dart';
import '../../data/local/expense_local_datasource.dart';
import '../../../../core/db/isar_service.dart';

// Provides the Isar instance
final isarProvider = Provider((ref) {
  return IsarService.instance.isar;
});

// Provides the local datasource
final expenseLocalDatasourceProvider = Provider((ref) {
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
final monthlyExpensesProvider =
    FutureProvider.family<List<Expense>, ({int month, int year})>((ref, arg) {
      final repository = ref.watch(expenseRepositoryProvider);
      return repository.getExpensesByMonth(arg.month, arg.year);
    });

// Provides category totals for a date range
final categoryTotalsProvider =
    FutureProvider.family<
      Map<ExpenseCategory, double>,
      ({DateTime from, DateTime to})
    >((ref, arg) {
      final repository = ref.watch(expenseRepositoryProvider);
      return repository.getCategoryTotals(arg.from, arg.to);
    });

// Provides the total amount spent in the current month
final totalThisMonthProvider = StreamProvider<double>((ref) {
  return ref.watch(expensesStreamProvider).select((asyncList) {
    return asyncList.when(
      data: (list) {
        final now = DateTime.now();
        return list
            .where((e) => e.date.month == now.month && e.date.year == now.year)
            .fold(0.0, (sum, item) => sum + item.amount);
      },
      error: (_, __) => 0.0,
      loading: () => 0.0,
    );
  });
});

// Provides the last 60 days of expenses (mainly for pattern engine)
final last60DaysProvider = FutureProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getLast60DaysExpenses();
});
