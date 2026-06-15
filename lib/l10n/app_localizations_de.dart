// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Intelligenter Ausgaben-Tracker';

  @override
  String get totalSpent => 'Gesamtausgaben';

  @override
  String get saved => 'Gespart';

  @override
  String get rentDue => 'Miete fällig';

  @override
  String get spendingBreakdown => 'Ausgabenübersicht';

  @override
  String get recentTransactions => 'Letzte Transaktionen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get theme => 'Design';

  @override
  String get currency => 'Währung';

  @override
  String get exportCsv => 'Daten exportieren (CSV)';

  @override
  String get smartNotifications => 'Intelligente Benachrichtigungen';

  @override
  String get profileSync => 'Profil & Synchronisierung';

  @override
  String get saveLimit => 'Limit speichern';

  @override
  String get addTransaction => 'Transaktion hinzufügen';

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
