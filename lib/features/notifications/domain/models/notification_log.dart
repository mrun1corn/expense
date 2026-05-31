import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_log.freezed.dart';
part 'notification_log.g.dart';

enum NotificationType {
  habitReminder,
  weeklyPattern,
  monthlyPattern,
  budgetWarning,
  budgetExceeded,
  inactivityNudge,
  aiInsightReady,
  weeklySummary,
  streak,
}

enum UserResponse {
  tapped,
  dismissed,
  quickAdded,
  customAdded,
  ignored,
}

@freezed
class NotificationLog with _$NotificationLog {
  const factory NotificationLog({
    required String id,
    required String
    patternId, // which pattern triggered this (can be empty for non-pattern alerts)
    required NotificationType type,
    required DateTime firedAt,
    required UserResponse
    response, // tapped | dismissed | quickAdded | customAdded | ignored
    double? addedAmount, // if user quick-added or custom-added
  }) = _NotificationLog;

  factory NotificationLog.fromJson(Map<String, dynamic> json) =>
      _$NotificationLogFromJson(json);
}
