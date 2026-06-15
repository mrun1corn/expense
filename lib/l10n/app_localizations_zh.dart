// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '智能记账助手';

  @override
  String get totalSpent => '总支出';

  @override
  String get saved => '已节省';

  @override
  String get rentDue => '房租截止日';

  @override
  String get spendingBreakdown => '消费细分';

  @override
  String get recentTransactions => '最近交易';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get currency => '货币';

  @override
  String get exportCsv => '导出数据 (CSV)';

  @override
  String get smartNotifications => '智能通知';

  @override
  String get profileSync => '个人资料与同步';

  @override
  String get saveLimit => '保存限制';

  @override
  String get addTransaction => '添加交易';

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
}
