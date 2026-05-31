import 'package:isar/isar.dart';
import '../../../../expenses/domain/models/expense.dart';
import '../../../domain/models/spending_pattern.dart';

part 'spending_pattern_isar.g.dart';

@collection
class SpendingPatternIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String type; // PatternType as string
  late String category; // ExpenseCategory as string
  late double typicalAmount;
  double? amountTolerance;
  int? timeSlotHour;
  int? timeSlotWindowMinutes;
  int? dayOfWeek;
  int? dayOfMonth;
  late int occurrences;
  late double confidence;
  late DateTime firstSeen;
  late DateTime lastSeen;
  late DateTime detectedAt;
  late bool notificationScheduled;
  late bool isDismissed;
  late bool isConfirmed;
  DateTime? nextScheduledAt;
  int? notificationId;

  SpendingPattern toDomain() {
    return SpendingPattern(
      id: id,
      type: PatternType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => PatternType.dailyHabit,
      ),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ExpenseCategory.other,
      ),
      typicalAmount: typicalAmount,
      amountTolerance: amountTolerance,
      timeSlotHour: timeSlotHour,
      timeSlotWindowMinutes: timeSlotWindowMinutes,
      dayOfWeek: dayOfWeek,
      dayOfMonth: dayOfMonth,
      occurrences: occurrences,
      confidence: confidence,
      firstSeen: firstSeen,
      lastSeen: lastSeen,
      detectedAt: detectedAt,
      notificationScheduled: notificationScheduled,
      isDismissed: isDismissed,
      isConfirmed: isConfirmed,
      nextScheduledAt: nextScheduledAt,
      notificationId: notificationId,
    );
  }

  static SpendingPatternIsar fromDomain(SpendingPattern pattern) {
    return SpendingPatternIsar()
      ..id = pattern.id
      ..type = pattern.type.name
      ..category = pattern.category.name
      ..typicalAmount = pattern.typicalAmount
      ..amountTolerance = pattern.amountTolerance
      ..timeSlotHour = pattern.timeSlotHour
      ..timeSlotWindowMinutes = pattern.timeSlotWindowMinutes
      ..dayOfWeek = pattern.dayOfWeek
      ..dayOfMonth = pattern.dayOfMonth
      ..occurrences = pattern.occurrences
      ..confidence = pattern.confidence
      ..firstSeen = pattern.firstSeen
      ..lastSeen = pattern.lastSeen
      ..detectedAt = pattern.detectedAt
      ..notificationScheduled = pattern.notificationScheduled
      ..isDismissed = pattern.isDismissed
      ..isConfirmed = pattern.isConfirmed
      ..nextScheduledAt = pattern.nextScheduledAt
      ..notificationId = pattern.notificationId;
  }
}
