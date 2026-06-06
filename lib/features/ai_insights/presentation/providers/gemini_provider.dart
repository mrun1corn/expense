import 'package:expense/features/ai_insights/data/remote/gemini_datasource.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<GeminiDatasource> geminiDatasourceProvider = Provider((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return GeminiDatasource(apiKey: apiKey);
});
