import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String>((ref) {
  return ApiKeyNotifier();
});

class ApiKeyNotifier extends StateNotifier<String> {
  ApiKeyNotifier() : super('') {
    _loadKey();
  }

  static const _prefKey = 'user_gemini_api_key';

  Future<void> _loadKey() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_prefKey) ?? '';
  }

  Future<void> setKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, key.trim());
    state = key.trim();
  }

  Future<void> clearKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    state = '';
  }
}
