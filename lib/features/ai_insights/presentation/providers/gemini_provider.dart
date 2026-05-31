import 'package:expense/features/ai_insights/data/remote/gemini_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<GeminiDatasource> geminiDatasourceProvider = Provider((ref) {
  return GeminiDatasource();
});