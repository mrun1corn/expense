import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/core/utils/connectivity_provider.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/data/local/expense_local_datasource.dart';
import 'package:expense/features/expenses/data/remote/expense_remote_datasource.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  SyncService(this._local, this._remote, this._isConnected, this._userId);
  final ExpenseLocalDatasource _local;
  final ExpenseRemoteDatasource _remote;
  final bool _isConnected;
  final String? _userId;

  Future<void> syncData() async {
    if (!_isConnected || _userId == null || _userId.isEmpty) return;

    try {
      // 0. Sync Gemini API Key first!
      final prefs = await SharedPreferences.getInstance();
      final localKey = prefs.getString('user_gemini_api_key') ?? '';
      
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(_userId);
      final userDoc = await userDocRef.get();
      
      if (userDoc.exists) {
        final remoteKey = userDoc.data()?['geminiApiKey'] as String?;
        if (remoteKey != null && remoteKey.isNotEmpty) {
          if (localKey != remoteKey) {
            await prefs.setString('user_gemini_api_key', remoteKey);
          }
        } else if (localKey.isNotEmpty) {
          await userDocRef.set({'geminiApiKey': localKey}, SetOptions(merge: true));
        }
      } else if (localKey.isNotEmpty) {
        await userDocRef.set({'geminiApiKey': localKey});
      }

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
      final since =
          latestLocal?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      final remoteUpdates = await _remote.getUpdatesSince(_userId, since);
      if (remoteUpdates.isNotEmpty) {
        // saveExpenses utilizes put() which overrides existing entries having the same ID.
        // If we strictly want LWW, we should compare updatedAt before overriding.
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
