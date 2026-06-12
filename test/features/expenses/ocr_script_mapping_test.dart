import 'package:expense/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  group('AddExpenseScreen.getOcrScriptForLanguage', () {
    test('maps zh to Chinese script', () {
      expect(AddExpenseScreen.getOcrScriptForLanguage('zh'), TextRecognitionScript.chinese);
    });

    test('maps ja to Japanese script', () {
      expect(AddExpenseScreen.getOcrScriptForLanguage('ja'), TextRecognitionScript.japanese);
    });

    test('maps ko to Korean script', () {
      expect(AddExpenseScreen.getOcrScriptForLanguage('ko'), TextRecognitionScript.korean);
    });

    test('maps hi to Devanagiri script', () {
      expect(AddExpenseScreen.getOcrScriptForLanguage('hi'), TextRecognitionScript.devanagiri);
    });

    test('defaults to Latin script for en, es, bn, etc.', () {
      expect(AddExpenseScreen.getOcrScriptForLanguage('en'), TextRecognitionScript.latin);
      expect(AddExpenseScreen.getOcrScriptForLanguage('bn'), TextRecognitionScript.latin);
      expect(AddExpenseScreen.getOcrScriptForLanguage('es'), TextRecognitionScript.latin);
      expect(AddExpenseScreen.getOcrScriptForLanguage('fr'), TextRecognitionScript.latin);
    });
  });
}
