// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_pattern.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpendingPatternImpl _$$SpendingPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$SpendingPatternImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PatternTypeEnumMap, json['type']),
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      typicalAmount: (json['typicalAmount'] as num).toDouble(),
      amountTolerance: (json['amountTolerance'] as num?)?.toDouble(),
      timeSlotHour: (json['timeSlotHour'] as num?)?.toInt(),
      timeSlotWindowMinutes: (json['timeSlotWindowMinutes'] as num?)?.toInt(),
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      occurrences: (json['occurrences'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
      firstSeen: DateTime.parse(json['firstSeen'] as String),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      notificationScheduled: json['notificationScheduled'] as bool? ?? false,
      isDismissed: json['isDismissed'] as bool? ?? false,
      isConfirmed: json['isConfirmed'] as bool? ?? false,
      nextScheduledAt: json['nextScheduledAt'] == null
          ? null
          : DateTime.parse(json['nextScheduledAt'] as String),
      notificationId: (json['notificationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpendingPatternImplToJson(
        _$SpendingPatternImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PatternTypeEnumMap[instance.type]!,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'typicalAmount': instance.typicalAmount,
      'amountTolerance': instance.amountTolerance,
      'timeSlotHour': instance.timeSlotHour,
      'timeSlotWindowMinutes': instance.timeSlotWindowMinutes,
      'dayOfWeek': instance.dayOfWeek,
      'dayOfMonth': instance.dayOfMonth,
      'occurrences': instance.occurrences,
      'confidence': instance.confidence,
      'firstSeen': instance.firstSeen.toIso8601String(),
      'lastSeen': instance.lastSeen.toIso8601String(),
      'detectedAt': instance.detectedAt.toIso8601String(),
      'notificationScheduled': instance.notificationScheduled,
      'isDismissed': instance.isDismissed,
      'isConfirmed': instance.isConfirmed,
      'nextScheduledAt': instance.nextScheduledAt?.toIso8601String(),
      'notificationId': instance.notificationId,
    };

const _$PatternTypeEnumMap = {
  PatternType.dailyHabit: 'dailyHabit',
  PatternType.weeklyRecurring: 'weeklyRecurring',
  PatternType.monthlyFixed: 'monthlyFixed',
  PatternType.categoryDrift: 'categoryDrift',
  PatternType.anomalySpike: 'anomalySpike',
};

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.food: 'food',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.utilities: 'utilities',
  ExpenseCategory.entertainment: 'entertainment',
  ExpenseCategory.shopping: 'shopping',
  ExpenseCategory.health: 'health',
  ExpenseCategory.education: 'education',
  ExpenseCategory.other: 'other',
};
