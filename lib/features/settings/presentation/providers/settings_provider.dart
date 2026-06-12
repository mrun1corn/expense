import 'dart:ui' as ui;
import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const _prefKey = 'app_theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_prefKey);
    if (val == 'light') {
      state = ThemeMode.light;
    } else if (val == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode.name);
    state = mode;
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('USD') {
    _loadCurrency();
  }

  static const _prefKey = 'app_currency';

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_prefKey)) {
      state = prefs.getString(_prefKey)!;
    } else {
      final autoDetected = PaymentSystemsManager.getDeviceCountryCode();
      final countryData = PaymentSystemsManager.getCountryData(autoDetected);
      state = countryData?.currencyCode ?? 'USD';
    }
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, currency);
    state = currency;
  }
}

final countryCodeProvider = StateNotifierProvider<CountryNotifier, String>((ref) {
  return CountryNotifier(ref);
});

class CountryNotifier extends StateNotifier<String> {
  final Ref _ref;
  CountryNotifier(this._ref) : super('US') {
    _loadCountry();
  }

  static const _prefKey = 'app_country_code';

  Future<void> _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDetected = PaymentSystemsManager.getDeviceCountryCode();
    final country = prefs.getString(_prefKey) ?? autoDetected;
    state = country;
    final hasManualLocale = prefs.getBool('has_manual_locale') ?? false;
    if (!hasManualLocale) {
      _ref.read(localeProvider.notifier).updateLocaleForCountry(country);
    }
  }

  Future<void> setCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, countryCode);
    state = countryCode;
    final hasManualLocale = prefs.getBool('has_manual_locale') ?? false;
    if (!hasManualLocale) {
      _ref.read(localeProvider.notifier).updateLocaleForCountry(countryCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final Ref _ref;
  LocaleNotifier(this._ref) : super(const Locale('en')) {
    _loadLocale();
  }

  static const _prefKey = 'app_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    Locale loadedLocale;
    if (prefs.containsKey(_prefKey)) {
      loadedLocale = Locale(prefs.getString(_prefKey)!);
    } else {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      if (['en', 'es', 'fr'].contains(deviceLocale.languageCode)) {
        loadedLocale = Locale(deviceLocale.languageCode);
      } else {
        final country = _ref.read(countryCodeProvider);
        loadedLocale = _getLocaleForCountry(country);
      }
    }
    state = loadedLocale;
    Intl.defaultLocale = loadedLocale.languageCode;
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    state = locale;
    Intl.defaultLocale = locale.languageCode;
  }

  Future<void> setManualLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_manual_locale', true);
    await setLocale(locale);
  }

  Future<void> clearManualLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_manual_locale');
    final country = _ref.read(countryCodeProvider);
    updateLocaleForCountry(country);
  }

  void updateLocaleForCountry(String countryCode) {
    final locale = _getLocaleForCountry(countryCode);
    setLocale(locale);
  }

  Locale _getLocaleForCountry(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'FR':
      case 'BE':
      case 'CH':
      case 'CA':
        return const Locale('fr');
      case 'ES':
      case 'MX':
      case 'AR':
      case 'CO':
      case 'PE':
      case 'CL':
      case 'VE':
      case 'EC':
      case 'GT':
      case 'CU':
      case 'BO':
      case 'DO':
      case 'HN':
      case 'PY':
      case 'SV':
      case 'CR':
      case 'PA':
      case 'UY':
      case 'NI':
      case 'PR':
        return const Locale('es');
      case 'BR':
      case 'PT':
      case 'AO':
      case 'MZ':
        return const Locale('pt');
      case 'DE':
      case 'AT':
        return const Locale('de');
      case 'IT':
        return const Locale('it');
      case 'JP':
        return const Locale('ja');
      case 'KR':
        return const Locale('ko');
      case 'CN':
      case 'TW':
      case 'HK':
        return const Locale('zh');
      case 'BD':
        return const Locale('bn');
      case 'TR':
        return const Locale('tr');
      case 'RU':
      case 'BY':
      case 'KZ':
        return const Locale('ru');
      case 'SA':
      case 'EG':
      case 'AE':
      case 'QA':
      case 'JO':
      case 'LB':
      case 'MA':
      case 'DZ':
        return const Locale('ar');
      case 'NL':
        return const Locale('nl');
      case 'DK':
        return const Locale('da');
      case 'FI':
        return const Locale('fi');
      case 'NO':
        return const Locale('no');
      case 'SE':
        return const Locale('sv');
      case 'PL':
        return const Locale('pl');
      case 'RO':
        return const Locale('ro');
      case 'UA':
        return const Locale('uk');
      case 'VN':
        return const Locale('vi');
      case 'GR':
        return const Locale('el');
      case 'HU':
        return const Locale('hu');
      case 'IL':
        return const Locale('he');
      case 'CZ':
        return const Locale('cs');
      case 'ZA':
        return const Locale('af');
      default:
        return const Locale('en');
    }
  }
}

