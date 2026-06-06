import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/core/db/isar_service.dart';
import 'package:expense/core/utils/connectivity_provider.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/budgets/data/local/isar/budget_isar.dart';
import 'package:expense/features/budgets/domain/models/budget.dart';
import 'package:expense/features/expenses/data/local/expense_local_datasource.dart';
import 'package:expense/features/expenses/data/remote/expense_remote_datasource.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
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
      final prefs = await SharedPreferences.getInstance();

      // 0. Sync Gemini API Key first!
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
        // Mark as synced locally & purge successfully synced soft-deleted records
        await _local.purgeDeletedAndMarkSynced(unsynced);
      }

      // 3. Pull remote changes (Last-Write-Wins based on last sync timestamp)
      final lastSyncStr = prefs.getString('last_sync_timestamp_$_userId') ?? '';
      final since = lastSyncStr.isNotEmpty 
          ? DateTime.parse(lastSyncStr) 
          : DateTime.fromMillisecondsSinceEpoch(0);

      final remoteUpdates = await _remote.getUpdatesSince(_userId, since);
      if (remoteUpdates.isNotEmpty) {
        final syncedRemote = remoteUpdates
            .map((e) => e.copyWith(isSynced: true))
            .toList();
        await _local.saveExpenses(syncedRemote);
      }

      // Update sync timestamp
      await prefs.setString('last_sync_timestamp_$_userId', DateTime.now().toIso8601String());

      // 4. Sync Budgets
      final isar = IsarService.instance.isar;
      
      // Assign empty guest budgets to the current user
      final guestBudgetsIsar = await isar.budgetIsars
          .filter()
          .userIdEqualTo('')
          .findAll();
      if (guestBudgetsIsar.isNotEmpty) {
        await isar.writeTxn(() async {
          for (final b in guestBudgetsIsar) {
            b.userId = _userId;
            await isar.budgetIsars.put(b);
          }
        });
      }

      // Push all local budgets to Firestore
      final localBudgets = await isar.budgetIsars
          .filter()
          .userIdEqualTo(_userId)
          .findAll();
      
      if (localBudgets.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final b in localBudgets) {
          final docRef = FirebaseFirestore.instance.collection('budgets').doc(b.id);
          batch.set(docRef, b.toDomain().toJson(), SetOptions(merge: true));
        }
        await batch.commit();
      }

      // Pull remote budgets from Firestore
      final budgetSnapshot = await FirebaseFirestore.instance
          .collection('budgets')
          .where('userId', isEqualTo: _userId)
          .get();
      
      final remoteBudgets = budgetSnapshot.docs
          .map((doc) => Budget.fromJson(doc.data()))
          .toList();
      
      if (remoteBudgets.isNotEmpty) {
        await isar.writeTxn(() async {
          for (final b in remoteBudgets) {
            final existing = await isar.budgetIsars
                .filter()
                .idEqualTo(b.id)
                .findFirst();
            final isarObj = BudgetIsar.fromDomain(b);
            if (existing != null) {
              isarObj.isarId = existing.isarId;
            }
            await isar.budgetIsars.put(isarObj);
          }
        });
      }

    } catch (e) {
      print('Sync failed: $e');
    }
  }
}
