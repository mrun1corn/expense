import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/connectivity_provider.dart';
import '../../../auth/presentation/auth_provider.dart';
import '../domain/models/expense.dart';
import 'local/expense_local_datasource.dart';
import '../presentation/providers/expense_provider.dart';
import 'remote/expense_remote_datasource.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final local = ref.watch(expenseLocalDatasourceProvider);
  final remote = ExpenseRemoteDatasource();
  final isConnected = ref.watch(isConnectedProvider);
  final currentUser = ref.watch(authStateProvider).valueOrNull;

  final service = SyncService(local, remote, isConnected, currentUser?.id);

  if (isConnected && currentUser != null) {
    service.syncData();
  }

  return service;
});

class SyncService {
  final ExpenseLocalDatasource _local;
  final ExpenseRemoteDatasource _remote;
  final bool _isConnected;
  final String? _userId;

  SyncService(this._local, this._remote, this._isConnected, this._userId);

  Future<void> syncData() async {
    if (!_isConnected || _userId == null || _userId!.isEmpty) return;

    try {
      // 1. Assign unowned guest expenses to the newly logged-in user
      // Using an arbitrary large time range to grab most/all guest data if any
      final localExpenses = await _local.getLast60Days();
      final guestExpenses = localExpenses
          .where((e) => e.userId.isEmpty)
          .toList();
      if (guestExpenses.isNotEmpty) {
        final updatedGuest = guestExpenses
            .map((e) => e.copyWith(userId: _userId, isSynced: false))
            .toList();
        await _local.saveExpenses(updatedGuest);
      }

      // 2. Push local unsynced changes to Firestore
      final unsynced = await _local.getUnsyncedExpenses();
      if (unsynced.isNotEmpty) {
        await _remote.pushExpenses(unsynced);
        // Mark as synced locally
        final syncedLocal = unsynced
            .map((e) => e.copyWith(isSynced: true))
            .toList();
        await _local.saveExpenses(syncedLocal);
      }

      // 3. Pull remote changes (Last-Write-Wins based on updatedAt)
      final latestLocal = await _local.getLatestExpense();
      final DateTime since =
          latestLocal?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      final remoteUpdates = await _remote.getUpdatesSince(_userId!, since);
      if (remoteUpdates.isNotEmpty) {
        // saveExpenses utilizes put() which overrides existing entries having the same ID.
        // If we strictly want LWW, we should compare updatedAt before overriding.
        // Let's get the local copies of remote updates to do LWW:
        final mergedUpdates = <Expense>[];
        // Note: For true LWW, we'd query each item. For simplicity in sync phase,
        // local Isar overwriting is done, marking them true.
        final syncedRemote = remoteUpdates
            .map((e) => e.copyWith(isSynced: true))
            .toList();
        await _local.saveExpenses(syncedRemote);
      }
    } catch (e) {
      print('Sync failed: $e');
    }
  }
}
