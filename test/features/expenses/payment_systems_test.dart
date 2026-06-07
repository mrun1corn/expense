import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentSystemsManager tests', () {
    test('allCountriesData is successfully parsed and not empty', () {
      final list = PaymentSystemsManager.allCountriesData;
      expect(list, isNotEmpty);
      expect(list.any((c) => c.countryCode == 'BD'), isTrue);
      expect(list.any((c) => c.countryCode == 'US'), isTrue);
      expect(list.any((c) => c.countryCode == 'IN'), isTrue);
    });

    test('getCountryData returns correct country data for valid code', () {
      final bdData = PaymentSystemsManager.getCountryData('BD');
      expect(bdData, isNotNull);
      expect(bdData!.country, 'Bangladesh');
      expect(bdData.currencyCode, 'BDT');
      expect(bdData.systems, isNotEmpty);
      expect(bdData.systems.any((s) => s.name == 'bKash'), isTrue);
    });

    test('getCountryData returns null for invalid country code', () {
      final invalidData = PaymentSystemsManager.getCountryData('INVALID');
      expect(invalidData, isNull);
    });

    test('getSystemNamesForCountry returns system names', () {
      final bdSystems = PaymentSystemsManager.getSystemNamesForCountry('BD');
      expect(bdSystems, contains('bKash'));
      expect(bdSystems, contains('Nagad'));

      final usSystems = PaymentSystemsManager.getSystemNamesForCountry('US');
      expect(usSystems, contains('Venmo'));
      expect(usSystems, contains('Zelle'));
    });

    test('getSystemTypeColor returns correct color category for known systems', () {
      // bKash (MFS)
      expect(PaymentSystemsManager.getSystemTypeColor('bKash'), 'mfs');
      // Venmo (Digital Wallet)
      expect(PaymentSystemsManager.getSystemTypeColor('Venmo'), 'wallet');
      // Zelle (RTP)
      expect(PaymentSystemsManager.getSystemTypeColor('Zelle'), 'rtp');
      // Rupay (Card Network)
      expect(PaymentSystemsManager.getSystemTypeColor('Rupay'), 'card');
      // DCEP (e-CNY) (CBDC)
      expect(PaymentSystemsManager.getSystemTypeColor('DCEP (e-CNY)'), 'cbdc');
      // Unknown system returns other
      expect(PaymentSystemsManager.getSystemTypeColor('UnknownSystem'), 'other');
    });

    test('getSupportedCountries lists and sorts countries properly', () {
      final list = PaymentSystemsManager.getSupportedCountries();
      expect(list, isNotEmpty);
      expect(list.any((item) => item['code'] == 'BD'), isTrue);
      expect(list.any((item) => item['code'] == 'US'), isTrue);

      // Check sorting
      for (int i = 0; i < list.length - 1; i++) {
        expect(list[i]['name']!.compareTo(list[i + 1]['name']!), lessThanOrEqualTo(0));
      }
    });
  });
}
