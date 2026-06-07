import 'dart:convert';
import 'dart:ui' as ui;
import 'package:expense/core/payment/payment_systems_data.dart';

class PaymentSystemInfo {
  final String name;
  final String type;
  final String operator;
  final String category;
  final String status;
  final double? usersMillion;
  final int? launched;

  PaymentSystemInfo({
    required this.name,
    required this.type,
    required this.operator,
    required this.category,
    required this.status,
    this.usersMillion,
    this.launched,
  });

  factory PaymentSystemInfo.fromJson(Map<String, dynamic> json) {
    return PaymentSystemInfo(
      name: json['name'] as String,
      type: json['type'] as String,
      operator: json['operator'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      usersMillion: json['users_million'] != null 
          ? (json['users_million'] as num).toDouble()
          : null,
      launched: json['launched'] != null ? json['launched'] as int : null,
    );
  }
}

class CountryPaymentSystems {
  final String country;
  final String countryCode;
  final String currency;
  final String currencyCode;
  final String currencySymbol;
  final String? regulator;
  final List<PaymentSystemInfo> systems;

  CountryPaymentSystems({
    required this.country,
    required this.countryCode,
    required this.currency,
    required this.currencyCode,
    required this.currencySymbol,
    this.regulator,
    required this.systems,
  });

  factory CountryPaymentSystems.fromJson(Map<String, dynamic> json) {
    final systemsList = (json['systems'] as List<dynamic>?)
            ?.map((e) => PaymentSystemInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return CountryPaymentSystems(
      country: json['country'] as String,
      countryCode: json['country_code'] as String,
      currency: json['currency'] as String,
      currencyCode: json['currency_code'] as String,
      currencySymbol: json['currency_symbol'] as String,
      regulator: json['regulator'] as String?,
      systems: systemsList,
    );
  }
}

class PaymentSystemsManager {
  static List<CountryPaymentSystems>? _cachedData;

  static List<CountryPaymentSystems> get allCountriesData {
    if (_cachedData != null) return _cachedData!;

    try {
      final decoded = jsonDecode(paymentSystemsRawJson) as Map<String, dynamic>;
      final regions = decoded['regions'] as List<dynamic>;
      final countriesList = <CountryPaymentSystems>[];

      for (final region in regions) {
        final countries = region['countries'] as List<dynamic>;
        for (final countryJson in countries) {
          countriesList.add(CountryPaymentSystems.fromJson(countryJson as Map<String, dynamic>));
        }
      }
      _cachedData = countriesList;
      return _cachedData!;
    } catch (e) {
      // Return empty list if parsing fails
      return [];
    }
  }

  // Get country code from device locale
  static String getDeviceCountryCode() {
    final code = ui.PlatformDispatcher.instance.locale.countryCode;
    return code != null && code.isNotEmpty ? code.toUpperCase() : 'US';
  }

  // Get details for a specific country by its 2-letter country code
  static CountryPaymentSystems? getCountryData(String countryCode) {
    final cleanCode = countryCode.trim().toUpperCase();
    try {
      return allCountriesData.firstWhere(
        (element) => element.countryCode.toUpperCase() == cleanCode,
      );
    } catch (_) {
      return null;
    }
  }

  // List of all supported country codes
  static List<Map<String, String>> getSupportedCountries() {
    return allCountriesData.map((e) => {
      'code': e.countryCode,
      'name': e.country,
    }).toList()..sort((a, b) => a['name']!.compareTo(b['name']!));
  }

  // Get system names for a country code
  static List<String> getSystemNamesForCountry(String countryCode) {
    final data = getCountryData(countryCode);
    if (data == null) return [];
    return data.systems.map((e) => e.name).toList();
  }

  // Check if system has a specific type and color
  static String getSystemTypeColor(String systemName) {
    // Look up system type across all data
    for (final country in allCountriesData) {
      for (final system in country.systems) {
        if (system.name.toLowerCase() == systemName.toLowerCase()) {
          switch (system.type.toUpperCase()) {
            case 'MFS':
              return 'mfs';
            case 'REAL-TIME PAYMENT RAIL':
            case 'RTP':
              return 'rtp';
            case 'DIGITAL WALLET':
            case 'WALLET':
              return 'wallet';
            case 'BANKING RAIL':
            case 'BANKING':
              return 'bank';
            case 'NEOBANK':
              return 'neo';
            case 'CARD NETWORK':
              return 'card';
            case 'CBDC':
              return 'cbdc';
            default:
              return 'other';
          }
        }
      }
    }
    return 'other';
  }
}
