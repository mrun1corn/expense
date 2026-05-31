import 'package:flutter_test/flutter_test.dart';
import 'package:expense/features/notifications/engine/pattern_detector.dart';

void main() {
  group('PatternDetector TimeSlots', () {
    test('getTimeSlot returns correct slots for given hours', () {
      expect(PatternDetector.getTimeSlot(DateTime(2024, 1, 1, 8, 0)), TimeSlot.morning);
      expect(PatternDetector.getTimeSlot(DateTime(2024, 1, 1, 12, 0)), TimeSlot.midday);
      expect(PatternDetector.getTimeSlot(DateTime(2024, 1, 1, 15, 0)), TimeSlot.afternoon);
      expect(PatternDetector.getTimeSlot(DateTime(2024, 1, 1, 20, 0)), TimeSlot.evening);
      expect(PatternDetector.getTimeSlot(DateTime(2024, 1, 1, 2, 0)), TimeSlot.night);
    });

    test('getTimeSlotHour returns correct midpoints', () {
      expect(PatternDetector.getTimeSlotHour(TimeSlot.morning), 8);
      expect(PatternDetector.getTimeSlotHour(TimeSlot.midday), 12);
      expect(PatternDetector.getTimeSlotHour(TimeSlot.afternoon), 16);
      expect(PatternDetector.getTimeSlotHour(TimeSlot.evening), 20);
      expect(PatternDetector.getTimeSlotHour(TimeSlot.night), 2);
    });
  });
}