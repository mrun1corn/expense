// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Smart Expense Tracker';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get saved => 'Saved';

  @override
  String get rentDue => 'Rent Due';

  @override
  String get spendingBreakdown => 'Spending Breakdown';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get currency => 'Currency';

  @override
  String get exportCsv => 'Export Data (CSV)';

  @override
  String get smartNotifications => 'Smart Notifications';

  @override
  String get profileSync => 'Profile & Sync';

  @override
  String get saveLimit => 'Save Limit';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get transactionAdded => 'Transaction added successfully!';

  @override
  String get transactionUpdated => 'Transaction updated successfully!';

  @override
  String get transactionDeleted => 'Transaction deleted successfully!';

  @override
  String get transactions => 'Transactions';

  @override
  String get noTransactionsThisMonth =>
      'No transactions recorded for this month.';

  @override
  String get deleted => 'Deleted';

  @override
  String get undo => 'UNDO';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';
}
