import 'package:expense/core/db/isar_service.dart';
import 'package:expense/features/expenses/data/local/isar/expense_isar.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/notifications/data/local/isar/spending_pattern_isar.dart';
import 'package:expense/features/notifications/domain/models/spending_pattern.dart';
import 'package:isar/isar.dart';

enum TimeSlot {
  morning,
  midday,
  afternoon,
  evening,
  night,
}

class PatternDetector {
  static TimeSlot getTimeSlot(DateTime time) {
    final hour = time.hour;
    if (hour >= 6 && hour < 10) return TimeSlot.morning;
    if (hour >= 10 && hour < 14) return TimeSlot.midday;
    if (hour >= 14 && hour < 18) return TimeSlot.afternoon;
    if (hour >= 18 && hour < 22) return TimeSlot.evening;
    return TimeSlot.night;
  }

  static int getTimeSlotHour(TimeSlot slot) {
    switch (slot) {
      case TimeSlot.morning: return 8; // Midpoint 6-10
      case TimeSlot.midday: return 12; // Midpoint 10-14
      case TimeSlot.afternoon: return 16; // Midpoint 14-18
      case TimeSlot.evening: return 20; // Midpoint 18-22
      case TimeSlot.night: return 2; // Midpoint 22-6
    }
  }

  static Future<void> onExpenseAdded(Expense expense) async {
    final isar = IsarService.instance.isar;

    // Fetch expenses for the last 60 days
    final sixtyDaysAgo = DateTime.now().subtract(const Duration(days: 60));
    final expensesIsar = await isar.expenseIsars
        .filter()
        .dateGreaterThan(sixtyDaysAgo)
        .findAll();

    final expenses = expensesIsar.map<Expense>((e) => e.toDomain()).toList();

    final patterns = await detectAll(expenses);

    // Save patterns to Isar
    await isar.writeTxn(() async {
      for (final pattern in patterns) {
        // Check if pattern exists (deduplication by type, category, timeSlot)
        final existing = await isar.spendingPatternIsars
            .filter()
            .typeEqualTo(pattern.type.name)
            .categoryEqualTo(pattern.category.name)
            .timeSlotHourEqualTo(pattern.timeSlotHour)
            .findFirst();

        if (existing != null) {
          // Update occurrences and lastSeen
          existing.occurrences = pattern.occurrences;
          existing.lastSeen = pattern.lastSeen;
          existing.confidence = pattern.confidence;
          existing.typicalAmount = pattern.typicalAmount;
          await isar.spendingPatternIsars.put(existing);
        } else {
          final newPattern = SpendingPatternIsar.fromDomain(pattern);
          await isar.spendingPatternIsars.put(newPattern);
        }
      }
    });
  }

  static Future<List<SpendingPattern>> detectAll(List<Expense> last60Days) async {
    final patterns = <SpendingPattern>[];
    
    // Group by category and time slot
    final buckets = <ExpenseCategory, Map<TimeSlot, List<Expense>>>{};

    for (final exp in last60Days) {
      final slot = getTimeSlot(exp.date);
      buckets.putIfAbsent(exp.category, () => {});
      buckets[exp.category]!.putIfAbsent(slot, () => []);
      buckets[exp.category]![slot]!.add(exp);
    }

    const tolerance = 0.15; // ±15% variance
    
    // Process buckets for daily habits
    buckets.forEach((category, slotMap) {
      slotMap.forEach((slot, expenses) {
        // Sort expenses by date
        expenses.sort((a, b) => a.date.compareTo(b.date));

        // Group expenses by calendar day
        final expensesByDay = <String, List<Expense>>{};
        for (final exp in expenses) {
          final dateKey = '${exp.date.year}-${exp.date.month.toString().padLeft(2, '0')}-${exp.date.day.toString().padLeft(2, '0')}';
          expensesByDay.putIfAbsent(dateKey, () => []);
          expensesByDay[dateKey]!.add(exp);
        }

        // If we don't have expenses on at least 3 days, skip
        if (expensesByDay.length < 3) return;

        // Calculate median amount
        final amounts = expenses.map((e) => e.amount).toList()..sort();
        final medianAmount = amounts[amounts.length ~/ 2];

        // Find longest consecutive-day streak within variance
        final sortedDays = expensesByDay.keys.toList()..sort();
        
        var currentStreak = 0;
        var maxStreak = 0;
        DateTime? firstSeen;
        DateTime? lastSeen;
        DateTime? currentStreakStart;

        for (var i = 0; i < sortedDays.length; i++) {
          final dayKey = sortedDays[i];
          final dayExpenses = expensesByDay[dayKey]!;
          
          // Check if any expense on this day is within tolerance
          final hasMatchingExpense = dayExpenses.any((e) => 
            e.amount >= medianAmount * (1 - tolerance) &&
            e.amount <= medianAmount * (1 + tolerance)
          );

          if (hasMatchingExpense) {
            final currentDate = dayExpenses.first.date;
            
            if (currentStreak == 0) {
              currentStreakStart = currentDate;
              currentStreak = 1;
            } else {
              // Check if it's the next day
              final prevDayKey = sortedDays[i - 1];
              final prevDate = DateTime.parse(prevDayKey);
              final currDate = DateTime.parse(dayKey);
              final diff = currDate.difference(prevDate).inDays;
              
              if (diff == 1) {
                currentStreak++;
              } else {
                if (currentStreak > maxStreak) {
                  maxStreak = currentStreak;
                  firstSeen = currentStreakStart;
                  lastSeen = DateTime.parse(sortedDays[i - 1]);
                }
                currentStreakStart = currentDate;
                currentStreak = 1;
              }
            }
          } else {
            if (currentStreak > maxStreak) {
              maxStreak = currentStreak;
              firstSeen = currentStreakStart;
              lastSeen = DateTime.parse(sortedDays[i - 1]);
            }
            currentStreak = 0;
          }
        }
        
        if (currentStreak > maxStreak) {
          maxStreak = currentStreak;
          firstSeen = currentStreakStart;
          lastSeen = DateTime.parse(sortedDays.last);
        }

        if (maxStreak >= 3 && firstSeen != null && lastSeen != null) {
          patterns.add(SpendingPattern(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            type: PatternType.dailyHabit,
            category: category,
            typicalAmount: medianAmount,
            amountTolerance: tolerance,
            timeSlotHour: getTimeSlotHour(slot),
            timeSlotWindowMinutes: 240, // 4 hours window
            occurrences: maxStreak,
            confidence: (maxStreak / 7.0).clamp(0.0, 1.0), // Simplified confidence
            firstSeen: firstSeen,
            lastSeen: lastSeen,
            detectedAt: DateTime.now(),
          ));
        }
      });
    });

    return patterns;
  }
}
