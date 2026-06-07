import 'dart:ui' as ui;
import 'package:expense/core/payment/payment_systems_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    _ref.read(localeProvider.notifier).updateLocaleForCountry(country);
  }

  Future<void> setCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, countryCode);
    state = countryCode;
    _ref.read(localeProvider.notifier).updateLocaleForCountry(countryCode);
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
    if (prefs.containsKey(_prefKey)) {
      state = Locale(prefs.getString(_prefKey)!);
    } else {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      if (['en', 'es', 'fr'].contains(deviceLocale.languageCode)) {
        state = Locale(deviceLocale.languageCode);
      } else {
        final country = _ref.read(countryCodeProvider);
        state = _getLocaleForCountry(country);
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    state = locale;
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
      case 'BR':
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
      default:
        return const Locale('en');
    }
  }
}

