// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationLogImpl _$$NotificationLogImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationLogImpl(
      id: json['id'] as String,
      patternId: json['patternId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      firedAt: DateTime.parse(json['firedAt'] as String),
      response: $enumDecode(_$UserResponseEnumMap, json['response']),
      addedAmount: (json['addedAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$NotificationLogImplToJson(
        _$NotificationLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patternId': instance.patternId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'firedAt': instance.firedAt.toIso8601String(),
      'response': _$UserResponseEnumMap[instance.response]!,
      'addedAmount': instance.addedAmount,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.habitReminder: 'habitReminder',
  NotificationType.weeklyPattern: 'weeklyPattern',
  NotificationType.monthlyPattern: 'monthlyPattern',
  NotificationType.budgetWarning: 'budgetWarning',
  NotificationType.budgetExceeded: 'budgetExceeded',
  NotificationType.inactivityNudge: 'inactivityNudge',
  NotificationType.aiInsightReady: 'aiInsightReady',
  NotificationType.weeklySummary: 'weeklySummary',
  NotificationType.streak: 'streak',
};

const _$UserResponseEnumMap = {
  UserResponse.tapped: 'tapped',
  UserResponse.dismissed: 'dismissed',
  UserResponse.quickAdded: 'quickAdded',
  UserResponse.customAdded: 'customAdded',
  UserResponse.ignored: 'ignored',
};
