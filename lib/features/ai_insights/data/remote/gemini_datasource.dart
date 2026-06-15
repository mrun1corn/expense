import 'dart:convert';
import 'dart:typed_data';
import 'package:expense/features/ai_insights/domain/models/chat_message.dart';
import 'package:expense/features/ai_insights/domain/models/gemini_prompts.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiDatasource {
  GeminiDatasource({required this.apiKey});
  final String apiKey;

  String _cleanJson(String text) {
    var s = text.trim();
    if (s.startsWith('```json')) {
      s = s.substring(7);
    } else if (s.startsWith('```')) {
      s = s.substring(3);
    }
    if (s.endsWith('```')) {
      s = s.substring(0, s.length - 3);
    }
    return s.trim();
  }

  Future<void> _checkRateLimit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      // 1. Min interval cooldown check (e.g., 2 seconds to prevent rapid spamming)
      final lastCallMs = prefs.getInt('gemini_last_call_time');
      if (lastCallMs != null) {
        final lastCallTime = DateTime.fromMillisecondsSinceEpoch(lastCallMs);
        if (now.difference(lastCallTime).inSeconds < 2) {
          throw Exception('Please wait a moment before making another request.');
        }
      }

      // 2. Daily limit check (maximum 60 requests per day)
      final todayStr = '${now.year}-${now.month}-${now.day}';
      final lastSavedDate = prefs.getString('gemini_limit_date');
      int count = prefs.getInt('gemini_limit_count') ?? 0;

      if (lastSavedDate == todayStr) {
        if (count >= 60) {
          throw Exception('Daily AI usage limit reached (60 requests/day). Please try again tomorrow.');
        }
        count++;
      } else {
        // New day, reset counter
        count = 1;
      }

      // Save updated limits
      await prefs.setInt('gemini_last_call_time', now.millisecondsSinceEpoch);
      await prefs.setString('gemini_limit_date', todayStr);
      await prefs.setInt('gemini_limit_count', count);
    } catch (e) {
      if (e.toString().contains('limit reached') || e.toString().contains('wait a moment')) {
        rethrow;
      }
      // Fallback on preference storage errors to avoid blocking the user
    }
  }

  Future<GenerativeModel> _getModel({String? systemInstruction}) async {
    // Enforce usage protection and rate limits
    await _checkRateLimit();

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
      print('Auto-categorize failed: $e');
      return 'other';
    }
  }

  Future<String> analyzeReceiptImage(Uint8List imageBytes, String mimeType, String language) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.multi([
          TextPart('Analyze this receipt image. Extract: '
              '1. Vendor/store name (under "title" field) '
              '2. Total amount charged (under "amount" field as a float/double) '
              '3. Main category of purchases (under "category" field, matching one of these values: food, transport, utilities, entertainment, shopping, health, education, other). '
              '4. A concise text summary of items, quantities, and individual prices (under "summary" field). '
              'Return ONLY a clean JSON object containing keys: "title", "amount", "category", "summary". Do not include markdown code block formatting or explanations. Just raw JSON. '
              'Important: The "summary" description must be in the language corresponding to language code: "$language".'),
          DataPart(mimeType, imageBytes),
        ]),
      ]);
      return _cleanJson(response.text?.trim() ?? '{}');
    } catch (e) {
      print('Gemini analyzeReceiptImage error: $e');
      rethrow;
    }
  }

  Future<String> analyzeReceiptText(String ocrText, String language) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text('Analyze this receipt text (extracted via OCR): \n"$ocrText"\n'
            'Extract: '
            '1. Vendor/store name (under "title" field) '
            '2. Total amount charged (under "amount" field as a float/double) '
            '3. Main category of purchases (under "category" field, matching one of these values: food, transport, utilities, entertainment, shopping, health, education, other). '
            '4. A concise text summary of items, quantities, and individual prices (under "summary" field). '
            'Return ONLY a clean JSON object containing keys: "title", "amount", "category", "summary". Do not include markdown code block formatting or explanations. Just raw JSON. '
            'Important: The "summary" description must be in the language corresponding to language code: "$language".'),
      ]);
      return _cleanJson(response.text?.trim() ?? '{}');
    } catch (e) {
      print('Gemini analyzeReceiptText error: $e');
      rethrow;
    }
  }

  Future<String> generateMonthlySummary(String expensesJson, String language) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.monthlySummary(expensesJson, language)),
      ]);
      return _cleanJson(response.text?.trim() ?? '{}');
    } catch (e) {
      final isRateLimit = e.toString().contains('limit reached') || e.toString().contains('wait a moment');
      final errorMsg = isRateLimit 
          ? e.toString().replaceAll('Exception: ', '') 
          : 'Failed to analyze expenses. Please try again later.';
      return jsonEncode({
        'summary': errorMsg,
        'tips': [
          {'type': 'warning', 'text': errorMsg}
        ]
      });
    }
  }

  Future<String> getBudgetAdvice(
    String category,
    double spent,
    double limit,
    String language,
  ) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.budgetAdvice(category, spent, limit, language)),
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
    String language,
  ) async {
    try {
      final model = await _getModel(
        systemInstruction: GeminiPrompts.systemChatPromptWithExpenses(expenses, language),
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
    String language,
  ) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.notificationCopy(trigger, context, language)),
      ]);
      return response.text?.trim() ?? trigger;
    } catch (e) {
      return trigger;
    }
  }

  Future<String> parseExpenseFromText(String text, String language) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text('Analyze this transaction description: "$text". '
            'Extract: '
            '1. Transaction title or merchant name (under "title" key) '
            '2. Transaction amount (under "amount" key as a float/double) '
            '3. Main category (under "category" key, matching one of these values: food, transport, utilities, entertainment, shopping, health, education, other). '
            '4. Transaction type (under "type" key, matching one of these values: expense, income, borrow, lend). '
            'Return ONLY a clean JSON object containing keys: "title", "amount", "category", "type". Do not include markdown code block formatting or explanations. Just raw JSON. '
            'Important: The transaction "title" should be in the language corresponding to language code: "$language".'),
      ]);
      return _cleanJson(response.text?.trim() ?? '{}');
    } catch (e) {
      print('Gemini parseExpenseFromText error: $e');
      rethrow;
    }
  }

  Future<String> generateDailySummary(String transactionsJson, String language) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.dailySummary(transactionsJson, language)),
      ]);
      return _cleanJson(response.text?.trim() ?? '{}');
    } catch (e) {
      if (e.toString().contains('limit reached') || e.toString().contains('wait a moment')) {
        return e.toString().replaceAll('Exception: ', '');
      }
      return "Failed to analyze today's expenses.";
    }
  }
}
