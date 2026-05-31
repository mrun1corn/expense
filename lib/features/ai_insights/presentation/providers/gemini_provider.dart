import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/remote/gemini_datasource.dart';

final geminiDatasourceProvider = Provider((ref) {
  return GeminiDatasource();
});