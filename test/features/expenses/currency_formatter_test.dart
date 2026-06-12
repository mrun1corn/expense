import 'package:expense/core/extensions/double_ext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    // Initialize localization data for formatting
    await initializeDateFormatting('en', null);
    await initializeDateFormatting('de', null);
    await initializeDateFormatting('bn', null);
  });

  group('CurrencyFormatter Extension Tests', () {
    test('formats currency correctly in English locale (en_US style)', () {
      const amount = 1234.56;
      final result = amount.toCurrencyString('USD', 'en');
      
      // Expected: "$1,234.56"
      expect(result, contains('\$'));
      expect(result, contains('1,234.56'));
    });

    test('formats currency correctly in German locale (de_DE style)', () {
      const amount = 1234.56;
      final result = amount.toCurrencyString('EUR', 'de');
      
      // Expected: "1.234,56 €" or "€ 1.234,56" (depending on package mapping, but comma for decimals is key)
      expect(result, contains('1.234,56'));
    });

    test('formats currency correctly in Bengali locale (bn_BD style)', () {
      const amount = 1234.56;
      final result = amount.toCurrencyString('BDT', 'bn');
      
      // Expected to contain Bengali numbers: ১,২৩৪.৫৬ and the ৳ symbol
      expect(result, contains('৳'));
      expect(result, contains('১,২৩৪.৫৬'));
    });
  });
}
