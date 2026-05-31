import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    required int occurrences,
    required double confidence,
    required DateTime firstSeen,
    required DateTime lastSeen,
    required DateTime detectedAt,
    double? amountTolerance,
    int? timeSlotHour,
    int? timeSlotWindowMinutes,
    int? dayOfWeek,
    int? dayOfMonth, // for monthly patterns
    @Default(false) bool notificationScheduled,
    @Default(false) bool isDismissed,
    @Default(false) bool isConfirmed, // user tapped "Yes, remind me"
    DateTime? nextScheduledAt,
    int? notificationId,
  }) = _SpendingPattern;

  factory SpendingPattern.fromJson(Map<String, dynamic> json) =>
      _$SpendingPatternFromJson(json);
}
