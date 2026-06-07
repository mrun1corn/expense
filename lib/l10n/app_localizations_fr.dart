// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi des Dépenses Intelligent';

  @override
  String get totalSpent => 'Total Dépensé';

  @override
  String get saved => 'Économisé';

  @override
  String get rentDue => 'Loyer Dû';

  @override
  String get spendingBreakdown => 'Répartition des Dépenses';

  @override
  String get recentTransactions => 'Transactions Récentes';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get currency => 'Devise';

  @override
  String get exportCsv => 'Exporter les Données (CSV)';

  @override
  String get smartNotifications => 'Notifications Intelligentes';

  @override
  String get profileSync => 'Profil & Synchro';

  @override
  String get saveLimit => 'Enregistrer la Limite';

  @override
  String get addTransaction => 'Ajouter une Transaction';
}
