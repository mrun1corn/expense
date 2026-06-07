import 'dart:typed_data';
import 'package:expense/features/ai_insights/domain/models/chat_message.dart';
import 'package:expense/features/ai_insights/domain/models/gemini_prompts.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class GeminiDatasource {

  GeminiDatasource({required this.apiKey});
  final String apiKey;

  Future<GenerativeModel> _getModel({String? systemInstruction}) async {
    // 1. Check if the user has entered their own API Key locally (Hermes-like flow)
    if (apiKey.isNotEmpty) {
      return GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: systemInstruction != null
            ? Content.system(systemInstruction)
            : null,
      );
    }

    // 2. Check if a static API Key is provided via Dart environment variables (recommended)
    const staticKey = String.fromEnvironment('GEMINI_API_KEY');
    if (staticKey.isNotEmpty) {
      return GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: staticKey,
        systemInstruction: systemInstruction != null
            ? Content.system(systemInstruction)
            : null,
      );
    }
    // 3. Throw exception if no key provided
    throw Exception('Gemini API key is required. Please set it in Settings.');
  }

  Future<String> predictCategory(String title) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.autoCategorize(title)),
      ]);
      return response.text?.trim() ?? 'other';
    } catch (e) {
      print(r'Auto-categorize failed: $e');
      return 'other';
    }
  }

  Future<String> analyzeReceiptImage(Uint8List imageBytes, String mimeType) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.multi([
          TextPart('Analyze this receipt image. Extract: '
              '1. Vendor/store name (under "title" field) '
              '2. Total amount charged (under "amount" field as a float/double) '
              '3. Main category of purchases (under "category" field, matching one of these values: food, transport, utilities, entertainment, shopping, health, education, other). '
              'Return ONLY a clean JSON object containing keys: "title", "amount", "category". Do not include markdown code block formatting or explanations. Just raw JSON.'),
          DataPart(mimeType, imageBytes),
        ]),
      ]);
      return response.text?.trim() ?? '{}';
    } catch (e) {
      print('Gemini analyzeReceiptImage error: $e');
      rethrow;
    }
  }

  Future<String> generateMonthlySummary(String expensesJson) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.monthlySummary(expensesJson)),
      ]);
      return response.text?.trim() ?? 'Unable to generate summary.';
    } catch (e) {
      return 'Failed to analyze expenses. Please try again later.';
    }
  }

  Future<String> getBudgetAdvice(
    String category,
    double spent,
    double limit,
  ) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.budgetAdvice(category, spent, limit)),
      ]);
      return response.text?.trim() ?? 'Keep an eye on your budget!';
    } catch (e) {
      return 'Keep an eye on your budget!';
    }
  }

  Future<String> sendChat(
    String message,
    List<ChatMessage> history,
    List<Expense> expenses,
  ) async {
    try {
      final model = await _getModel(
        systemInstruction: GeminiPrompts.systemChatPromptWithExpenses(expenses),
      );
      
      // Limit history passed to Gemini to prevent exceeding context limits/cost
      final recentHistory = history.length > 20
          ? history.sublist(history.length - 20)
          : history;

      final cleanHistory = <Content>[];
      var expectedRole = 'user';
      for (final msg in recentHistory) {
        final role = msg.isUser ? 'user' : 'model';
        if (role == expectedRole) {
          cleanHistory.add(Content(role, [TextPart(msg.text)]));
          expectedRole = role == 'user' ? 'model' : 'user';
        }
      }

      // The history passed to startChat must end with 'model' so that
      // the next message sent by sendMessage (which is 'user') alternates correctly.
      if (cleanHistory.isNotEmpty && cleanHistory.last.role == 'user') {
        cleanHistory.removeLast();
      }

      final chat = model.startChat(history: cleanHistory);

      final response = await chat.sendMessage(Content.text(message));
      return response.text?.trim() ?? 'I could not understand that.';
    } catch (e) {
      print('Gemini sendChat error: $e');
      rethrow;
    }
  }

  Future<String> generateNotificationCopy(
    String trigger,
    String context,
  ) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.notificationCopy(trigger, context)),
      ]);
      return response.text?.trim() ?? trigger;
    } catch (e) {
      return trigger;
    }
  }

  Future<String> parseExpenseFromText(String text) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text('Analyze this transaction description: "$text". '
            'Extract: '
            '1. Transaction title or merchant name (under "title" key) '
            '2. Transaction amount (under "amount" key as a float/double) '
            '3. Main category (under "category" key, matching one of these values: food, transport, utilities, entertainment, shopping, health, education, other). '
            '4. Transaction type (under "type" key, matching one of these values: expense, income, borrow, lend). '
            'Return ONLY a clean JSON object containing keys: "title", "amount", "category", "type". Do not include markdown code block formatting or explanations. Just raw JSON.'),
      ]);
      return response.text?.trim() ?? '{}';
    } catch (e) {
      print('Gemini parseExpenseFromText error: $e');
      rethrow;
    }
  }
}
