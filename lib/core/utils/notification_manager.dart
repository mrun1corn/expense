import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense/features/notifications/engine/action_handlers.dart';
import 'package:expense/features/notifications/engine/pattern_detector.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await PatternDetector.runDailyScan();
      return Future.value(true);
    } catch (e) {
      debugPrint('Background scan failed: $e');
      return Future.value(false);
    }
  });
}

class NotificationManager {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, // icon
      [
        NotificationChannel(
          channelGroupKey: 'habit_reminders_group',
          channelKey: 'habit_reminders',
          channelName: 'Habit Reminders',
          channelDescription: 'Notification channel for habit reminders',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'budget_alerts_group',
          channelKey: 'budget_alerts',
          channelName: 'Budget Alerts',
          channelDescription: 'Notification channel for budget limits',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'anomaly_alerts_group',
          channelKey: 'anomaly_alerts',
          channelName: 'Anomaly Alerts',
          channelDescription: 'Notification channel for spending anomalies',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'streak_milestones_group',
          channelKey: 'streak_milestones',
          channelName: 'Streak Milestones',
          channelDescription: 'Notification channel for streak milestones',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
        ),
        NotificationChannel(
          channelGroupKey: 'daily_summaries_group',
          channelKey: 'daily_summaries',
          channelName: 'Daily Summaries',
          channelDescription: 'Notification channel for daily summaries',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
        ),
        NotificationChannel(
          channelGroupKey: 'system_updates_group',
          channelKey: 'system_updates',
          channelName: 'System Updates',
          channelDescription: 'Notification channel for system updates',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'habit_reminders_group',
          channelGroupName: 'Habit Reminders Group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'budget_alerts_group',
          channelGroupName: 'Budget Alerts Group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'anomaly_alerts_group',
          channelGroupName: 'Anomaly Alerts Group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'streak_milestones_group',
          channelGroupName: 'Streak Milestones Group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'daily_summaries_group',
          channelGroupName: 'Daily Summaries Group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'system_updates_group',
          channelGroupName: 'System Updates Group',
        ),
      ],
      debug: true,
    );
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: ActionHandlers.onActionReceivedMethod,
    );
  }

  static Future<bool> requestPermission() async {
    var isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  static Future<void> initWorkmanager() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
    await Workmanager().registerPeriodicTask(
      'daily_pattern_scan_task',
      'dailyPatternScanTask',
      frequency: const Duration(hours: 24),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
