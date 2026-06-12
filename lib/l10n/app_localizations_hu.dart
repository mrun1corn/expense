// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

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
}
