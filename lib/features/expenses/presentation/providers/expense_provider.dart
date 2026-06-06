import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/expenses/data/expense_repository_impl.dart';
import 'package:expense/features/expenses/data/local/expense_local_datasource.dart';
import 'package:expense/features/expenses/domain/expense_repository.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// Provides the total expenses (spent) in the current month
final totalExpensesThisMonthProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(expensesStreamProvider).whenData((list) {
    final now = DateTime.now();
    return list
        .where((e) => e.date.month == now.month && e.date.year == now.year && e.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount);
  });
});

// Provides the total income in the current month
final totalIncomeThisMonthProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(expensesStreamProvider).whenData((list) {
    final now = DateTime.now();
    return list
        .where((e) => e.date.month == now.month && e.date.year == now.year && e.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);
  });
});

// Provides the net balance (income - expenses) in the current month
final netBalanceThisMonthProvider = Provider<AsyncValue<double>>((ref) {
  final incomeAsync = ref.watch(totalIncomeThisMonthProvider);
  final expensesAsync = ref.watch(totalExpensesThisMonthProvider);
  
  return incomeAsync.when(
    data: (income) => expensesAsync.when(
      data: (expenses) => AsyncValue.data(income - expenses),
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    ),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

// Provides total active borrowings
final activeBorrowTotalProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(expensesStreamProvider).whenData((list) {
    final now = DateTime.now();
    return list
        .where((e) => e.date.month == now.month && e.date.year == now.year && e.type == TransactionType.borrow)
        .fold(0, (sum, item) => sum + item.amount);
  });
});

// Provides total active lendings
final activeLendTotalProvider = Provider<AsyncValue<double>>((ref) {
  return ref.watch(expensesStreamProvider).whenData((list) {
    final now = DateTime.now();
    return list
        .where((e) => e.date.month == now.month && e.date.year == now.year && e.type == TransactionType.lend)
        .fold(0, (sum, item) => sum + item.amount);
  });
});

// Provides the total amount spent in the current month (backwards compatibility alias)
final Provider<AsyncValue<double>> totalThisMonthProvider = totalExpensesThisMonthProvider;

// Provides the last 60 days of expenses (mainly for pattern engine)
final last60DaysProvider = FutureProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getLast60DaysExpenses();
});

class RentSettings {
  const RentSettings({required this.amount, required this.dueDay});

  final double amount;
  final int dueDay;
}

class RentSettingsNotifier extends StateNotifier<RentSettings> {
  RentSettingsNotifier() : super(const RentSettings(amount: 1850, dueDay: 1)) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final amt = prefs.getDouble('rent_tracker_amount') ?? 1850.0;
    final day = prefs.getInt('rent_tracker_due_day') ?? 1;
    state = RentSettings(amount: amt, dueDay: day);
  }

  Future<void> updateSettings(double amount, int dueDay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rent_tracker_amount', amount);
    await prefs.setInt('rent_tracker_due_day', dueDay);
    state = RentSettings(amount: amount, dueDay: dueDay);
  }
}

final rentSettingsProvider = StateNotifierProvider<RentSettingsNotifier, RentSettings>((ref) {
  return RentSettingsNotifier();
});
