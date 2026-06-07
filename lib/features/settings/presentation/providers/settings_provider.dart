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
  return CountryNotifier();
});

class CountryNotifier extends StateNotifier<String> {
  CountryNotifier() : super('US') {
    _loadCountry();
  }

  static const _prefKey = 'app_country_code';

  Future<void> _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final autoDetected = PaymentSystemsManager.getDeviceCountryCode();
    state = prefs.getString(_prefKey) ?? autoDetected;
  }

  Future<void> setCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, countryCode);
    state = countryCode;
  }
}

