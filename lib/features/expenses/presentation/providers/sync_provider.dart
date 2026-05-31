import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../data/remote/expense_remote_datasource.dart';
import 'expense_provider.dart';

final expenseRemoteDatasourceProvider = Provider((ref) {
  return ExpenseRemoteDatasource();
});

// Listener for active cloud sync when app is open
final activeCloudSyncProvider = Provider<void>((ref) {
  final currentUser = ref.watch(authStateProvider).valueOrNull;
  if (currentUser == null) return;

  final remote = ref.watch(expenseRemoteDatasourceProvider);
  final local = ref.watch(expenseLocalDatasourceProvider);

  final sub = remote.streamUserExpenses(currentUser.id).listen((
    remoteExpenses,
  ) async {
    if (remoteExpenses.isNotEmpty) {
      final syncedRemote = remoteExpenses
          .map((e) => e.copyWith(isSynced: true))
          .toList();
      await local.saveExpenses(syncedRemote);
    }
  });

  ref.onDispose(() {
    sub.cancel();
  });
});
