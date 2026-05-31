import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../expenses/domain/models/expense.dart';

part 'spending_pattern.freezed.dart';
part 'spending_pattern.g.dart';

enum PatternType {
  dailyHabit, // Same amount, same time window, N consecutive days
  weeklyRecurring, // Same amount+category, same day of week, N weeks
  monthlyFixed, // Same amount, same day of month (rent, subscriptions)
  categoryDrift, // Spending in category trending upward week-over-week
  anomalySpike, // Single expense unusually large vs. category average
}

@freezed
class SpendingPattern with _$SpendingPattern {
  const factory SpendingPattern({
    required String id,
    required PatternType type,
    required ExpenseCategory category,
    required double typicalAmount,
    double? amountTolerance, // ±% acceptable variance (default 15%)
    int? timeSlotHour, // hour of day the pattern peaks (e.g. 18 = 6pm)
    int? timeSlotWindowMinutes, // how wide the time window is (e.g. 60)
    int? dayOfWeek, // 1=Mon...7=Sun for weekly patterns
    int? dayOfMonth, // for monthly patterns
    required int occurrences, // how many times this was observed
    required double confidence, // 0.0–1.0 (occurrences / possible slots)
    required DateTime firstSeen,
    required DateTime lastSeen,
    required DateTime detectedAt,
    @Default(false) bool notificationScheduled,
    @Default(false) bool isDismissed,
    @Default(false) bool isConfirmed, // user tapped "Yes, remind me"
    DateTime? nextScheduledAt,
    int? notificationId,
  }) = _SpendingPattern;

  factory SpendingPattern.fromJson(Map<String, dynamic> json) =>
      _$SpendingPatternFromJson(json);
}
