// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rastreador de Gastos Inteligente';

  @override
  String get totalSpent => 'Total Gastado';

  @override
  String get saved => 'Ahorrado';

  @override
  String get rentDue => 'Alquiler Vencido';

  @override
  String get spendingBreakdown => 'Desglose de Gastos';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get settings => 'Ajustes';

  @override
  String get theme => 'Tema';

  @override
  String get currency => 'Moneda';

  @override
  String get exportCsv => 'Exportar Datos (CSV)';

  @override
  String get smartNotifications => 'Notificaciones Inteligentes';

  @override
  String get profileSync => 'Perfil y Sincronización';

  @override
  String get saveLimit => 'Guardar Límite';

  @override
  String get addTransaction => 'Agregar Transacción';

  @override
  String get transactionAdded => 'Transaction added successfully!';

  @override
  String get transactionUpdated => 'Transaction updated successfully!';

  @override
  String get transactionDeleted => 'Transaction deleted successfully!';
}
