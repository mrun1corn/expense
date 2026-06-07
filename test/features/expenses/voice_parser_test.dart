import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddExpenseScreen.localParseVoiceText', () {
    test('parses spent amount and title from description', () {
      final res = AddExpenseScreen.localParseVoiceText('spent 12.50 on grocery');
      expect(res['amount'], 12.50);
      expect(res['title'], 'Grocery');
      expect(res['category'], ExpenseCategory.other);
      expect(res['type'], TransactionType.expense);
    });

    test('parses numbers without spent prefix or stop words', () {
      final res = AddExpenseScreen.localParseVoiceText('starbucks coffee 5.99');
      expect(res['amount'], 5.99);
      expect(res['title'], 'Starbucks coffee');
    });

    test('handles input without any numbers gracefully', () {
      final res = AddExpenseScreen.localParseVoiceText('lunch with colleagues');
      expect(res['amount'], 0.0);
      expect(res['title'], 'Lunch with colleagues');
    });

    test('handles empty input gracefully', () {
      final res = AddExpenseScreen.localParseVoiceText('');
      expect(res['amount'], 0.0);
      expect(res['title'], 'Voice Transaction');
    });

    test('strips multiple consecutive spaces and trims', () {
      final res = AddExpenseScreen.localParseVoiceText('  spent   45   on   electricity bill  ');
      expect(res['amount'], 45.0);
      expect(res['title'], 'Electricity bill');
    });
  });
}
