class GeminiPrompts {
  static String autoCategorize(String title) => r'''
You are an intelligent expense categorizer. Given the expense title "$title", determine the most appropriate category from the following list:
- food
- transport
- utilities
- entertainment
- shopping
- health
- education
- other

Respond ONLY with the exact lowercase category name. Do not include any other text or punctuation.
''';

  static String monthlySummary(String expensesJson) => r'''
Analyze the following JSON list of expenses for this month. 
Provide a short, 3-sentence summary of the spending behavior, highlighting the biggest spending category and offering one practical savings tip.
Expenses: $expensesJson
''';

  static String budgetAdvice(String category, double spent, double limit) => r'''
The user has spent $spent on $category, and their budget limit is $limit.
Give a brief, friendly, 2-sentence piece of advice to help them stay under budget or adjust their habits.
''';

  static String systemChatPrompt = '''
You are SmartSpend AI, an intelligent, friendly, and concise financial assistant built into an expense tracking app.
Your goal is to help the user understand their spending habits, provide savings tips, and answer questions about their data.
Always be encouraging, concise, and professional.
''';

  static String notificationCopy(String trigger, String context) => r'''
You are the smart assistant for SmartSpend. An alert triggered: "$trigger".
Context: $context
Write a friendly, single-sentence push notification message to the user.
Keep it short (under 60 characters) and actionable.
''';
}