import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/notifications/data/local/isar/notification_log_isar.dart';
import 'package:expense/features/notifications/domain/models/notification_log.dart';
import 'package:expense/features/notifications/domain/models/spending_pattern.dart';

class NotificationScheduler {
  static Future<void> schedulePatternNotification(SpendingPattern pattern) async {
    var scheduledDate = DateTime.now();

    if (pattern.timeSlotHour != null) {
      scheduledDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        pattern.timeSlotHour!,
      );
      if (scheduledDate.isBefore(DateTime.now())) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    } else {
      // Default to slightly in the future if no time slot provided
      scheduledDate = scheduledDate.add(const Duration(minutes: 5));
    }

    // Quiet hours: 11 PM (23) to 7 AM (7)
    if (scheduledDate.hour >= 23) {
      scheduledDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        7,
      ).add(const Duration(days: 1));
    } else if (scheduledDate.hour < 7) {
      scheduledDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        7,
      );
    }

    var channelKey = 'habit_reminders';
    var logType = NotificationType.habitReminder;
    var title = '';
    var body = '';

    switch (pattern.type) {
      case PatternType.dailyHabit:
        channelKey = 'habit_reminders';
        logType = NotificationType.habitReminder;
        title = 'Daily Habit';
        body = 'Did you spend \$${pattern.typicalAmount.toStringAsFixed(2)} on ${pattern.category.name}?';
      case PatternType.weeklyRecurring:
        channelKey = 'habit_reminders';
        logType = NotificationType.weeklyPattern;
        title = 'Weekly Recurring';
        body = 'Did you spend \$${pattern.typicalAmount.toStringAsFixed(2)} on ${pattern.category.name}?';
      case PatternType.monthlyFixed:
        channelKey = 'habit_reminders';
        logType = NotificationType.monthlyPattern;
        title = 'Monthly Fixed';
        body = 'Did you spend \$${pattern.typicalAmount.toStringAsFixed(2)} on ${pattern.category.name}?';
      case PatternType.categoryDrift:
        channelKey = 'anomaly_alerts';
        logType = NotificationType.budgetWarning;
        title = 'Spending Trend';
        body = 'Your ${pattern.category.name} spending is trending up.';
      case PatternType.anomalySpike:
        channelKey = 'anomaly_alerts';
        logType = NotificationType.budgetExceeded;
        title = 'Unusual Spend';
        body = 'Large expense detected in ${pattern.category.name}.';
    }

    final notificationId = pattern.hashCode.abs() % 100000;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: channelKey,
        title: title,
        body: body,
        category: NotificationCategory.Reminder,
        payload: {
          'patternId': pattern.id,
          'type': logType.name,
        },
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );

    // Save log to Isar
    final isar = await IsarService.getBackgroundInstance();
    final logIsar = NotificationLogIsar()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..patternId = pattern.id
      ..type = logType.name
      ..firedAt = scheduledDate
      ..response = UserResponse.ignored.name; // Initial state

    await isar.writeTxn(() async {
      await isar.notificationLogIsars.put(logIsar);
    });
  }
}
