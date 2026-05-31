import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/gemini_prompts.dart';

class _OAuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String _token;

  _OAuthHttpClient(this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer \$_token';
    return _inner.send(request);
  }
}

class GeminiDatasource {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GenerativeModel> _getModel({String? systemInstruction}) async {
    final googleUser = _googleSignIn.currentUser;
    if (googleUser == null) throw Exception('User not signed in');

    final auth = await googleUser.authentication;
    final token = auth.accessToken;
    if (token == null) throw Exception('Failed to get OAuth token');

    final httpClient = _OAuthHttpClient(token);

    return GenerativeModel(
      model: 'gemini-1.5-flash',
      // We pass an empty string for apiKey because we use the Bearer token in the custom HTTP client
      apiKey: '',
      httpClient: httpClient,
      systemInstruction: systemInstruction != null
          ? Content.system(systemInstruction)
          : null,
    );
  }

  Future<String> predictCategory(String title) async {
    try {
      final model = await _getModel();
      final response = await model.generateContent([
        Content.text(GeminiPrompts.autoCategorize(title)),
      ]);
      return response.text?.trim() ?? 'other';
    } catch (e) {
      print('Auto-categorize failed: \$e');
      return 'other';
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

  Future<String> sendChat(String message) async {
    try {
      final model = await _getModel(
        systemInstruction: GeminiPrompts.systemChatPrompt,
      );
      final response = await model.generateContent([Content.text(message)]);
      return response.text?.trim() ?? 'I could not understand that.';
    } catch (e) {
      return 'Sorry, I am having trouble connecting right now.';
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
}
