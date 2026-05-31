import 'package:expense/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:expense/features/budgets/domain/models/budget.dart';
import 'package:expense/features/budgets/domain/repositories/budget_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl();
});

final StreamProviderFamily<List<Budget>, DateTime> budgetsStreamProvider = StreamProvider.family<List<Budget>, DateTime>((ref, date) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchBudgets(date.month, date.year);
});
