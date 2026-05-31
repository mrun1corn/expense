import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/expenses/data/local/isar/expense_isar.dart';
import '../../features/budgets/data/local/isar/budget_isar.dart';
import '../../features/notifications/data/local/isar/spending_pattern_isar.dart';
import '../../features/notifications/data/local/isar/notification_log_isar.dart';
import '../../features/ai_insights/data/local/isar/chat_message_isar.dart';

class IsarService {
  static const String _dbName = 'smart_expense_tracker';
  late final Isar isar;

  // Private constructor
  IsarService._(this.isar);

  // Singleton instance
  static IsarService? _instance;

  static IsarService get instance {
    if (_instance == null) {
      throw StateError(
        'IsarService has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  // Initialize the database for the main isolate
  static Future<IsarService> initialize() async {
    if (_instance != null) return _instance!;

    final dir = await getApplicationDocumentsDirectory();
    final isarInstance =
        Isar.getInstance(_dbName) ??
        await Isar.open(
          [
            ExpenseIsarSchema,
            BudgetIsarSchema,
            SpendingPatternIsarSchema,
            NotificationLogIsarSchema,
            ChatMessageIsarSchema,
          ],
          directory: dir.path,
          name: _dbName,
        );

    _instance = IsarService._(isarInstance);
    return _instance!;
  }

  // Thread-safe background isolate helper (resolves Risk A)
  static Future<Isar> getBackgroundInstance() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.getInstance(_dbName) ??
        await Isar.open(
          [
            ExpenseIsarSchema,
            BudgetIsarSchema,
            SpendingPatternIsarSchema,
            NotificationLogIsarSchema,
            ChatMessageIsarSchema,
          ],
          directory: dir.path,
          name: _dbName,
        );
  }
}
