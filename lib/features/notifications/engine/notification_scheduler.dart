import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/notifications/data/local/isar/notification_log_isar.dart';
import 'package:expense/features/notifications/domain/models/notification_log.dart';
import 'package:expense/features/notifications/domain/models/spending_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScheduler {
  static Future<void> schedulePatternNotification(SpendingPattern pattern) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check if notifications are enabled
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    if (!enabled) return;

    // 2. Check daily notifications cap
    final dailyCap = prefs.getDouble('notifications_daily_cap') ?? 5.0;
    
    final isar = await IsarService.getBackgroundInstance();
    final nowTime = DateTime.now();
    final todayStart = DateTime(nowTime.year, nowTime.month, nowTime.day);
    final todayEnd = DateTime(nowTime.year, nowTime.month, nowTime.day, 23, 59, 59, 999);

    final count = await isar.notificationLogIsars
        .filter()
        .firedAtBetween(todayStart, todayEnd)
        .count();

    if (count >= dailyCap.toInt()) {
      return; // Daily cap reached
    }

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

    // 3. Apply quiet hours check from preferences
    final quietStartHour = prefs.getInt('notifications_quiet_start_hour') ?? 23;
    final quietEndHour = prefs.getInt('notifications_quiet_end_hour') ?? 7;
    final quietEndMinute = prefs.getInt('notifications_quiet_end_minute') ?? 0;

    final scheduledHour = scheduledDate.hour;
    var inQuietHours = false;
    if (quietStartHour > quietEndHour) {
      inQuietHours = scheduledHour >= quietStartHour || scheduledHour < quietEndHour;
    } else {
      inQuietHours = scheduledHour >= quietStartHour && scheduledHour < quietEndHour;
    }

    if (inQuietHours) {
      if (scheduledHour >= quietStartHour) {
        scheduledDate = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          quietEndHour,
          quietEndMinute,
        ).add(const Duration(days: 1));
      } else {
        scheduledDate = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          quietEndHour,
          quietEndMinute,
        );
      }
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
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

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
          'amount': pattern.typicalAmount.toString(),
          'category': pattern.category.name,
          'title': '${pattern.category.name[0].toUpperCase()}${pattern.category.name.substring(1)} Spend',
          'currency': 'USD',
          'userId': userId,
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'QUICK_ADD',
          label: 'Quick Add',
          actionType: ActionType.SilentAction,
        ),
        NotificationActionButton(
          key: 'SKIP_TODAY',
          label: 'Skip Today',
          actionType: ActionType.SilentAction,
        ),
      ],
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );

    // Save log to Isar
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
