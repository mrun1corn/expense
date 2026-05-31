import 'dart:developer' as developer;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isar/isar.dart';

import '../../../../core/db/isar_service.dart';
import '../../../expenses/data/local/isar/expense_isar.dart';
import '../../../expenses/domain/models/expense.dart';

class ActionHandlers {
  /// Global `@pragma('vm:entry-point')` action handler for awesome_notifications.
  /// This must be a static or top-level method to work in a background isolate.
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    developer.log('Notification action received: ${receivedAction.buttonKeyPressed}');

    final payload = receivedAction.payload;

    if (receivedAction.buttonKeyPressed == 'QUICK_ADD') {
      await _handleQuickAdd(payload);
    } else if (receivedAction.buttonKeyPressed == 'CUSTOM_ADD') {
      // The CUSTOM_ADD button usually opens the app to the add expense screen.
      // That can be handled in the foreground by listening to the stream or 
      // relying on the action to launch the app.
      developer.log('CUSTOM_ADD action triggered.');
    } else if (receivedAction.buttonKeyPressed == 'SKIP_TODAY') {
      // Record or acknowledge that the user skipped the expense today.
      developer.log('SKIP_TODAY action triggered.');
    } else {
      // Handle generic or default taps if necessary
      developer.log('Default notification tap or unhandled action.');
    }
  }

  static Future<void> _handleQuickAdd(Map<String, String?>? payload) async {
    if (payload == null) {
      developer.log('Error: Payload is null for QUICK_ADD action');
      return;
    }

    final amountStr = payload['amount'];
    final categoryStr = payload['category'];
    final titleStr = payload['title'];
    final currencyStr = payload['currency'];

    if (amountStr == null) {
      developer.log('Error: Amount is missing in QUICK_ADD payload');
      return;
    }

    final amount = double.tryParse(amountStr) ?? 0.0;
    if (amount <= 0) {
      developer.log('Error: Invalid amount parsed in QUICK_ADD payload');
      return;
    }

    // Initialize thread-safe Isar instance for background isolate
    final isar = await IsarService.getBackgroundInstance();

    final now = DateTime.now();

    final expense = ExpenseIsar()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..userId = payload['userId'] ?? 'background_isolate'
      ..amount = amount
      ..currency = currencyStr ?? 'USD'
      ..category = categoryStr ?? ExpenseCategory.other.name
      ..date = now
      ..title = titleStr ?? 'Quick Expense'
      ..isSynced = false
      ..createdAt = now
      ..updatedAt = now;

    await isar.writeTxn(() async {
      await isar.expenseIsars.put(expense);
    });

    developer.log('QUICK_ADD successful. Added expense for \$amount');
  }
}
