import 'dart:convert';

import 'package:expense/features/ai_insights/presentation/providers/gemini_provider.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final AutoDisposeFutureProvider<String> monthlySummaryProvider = FutureProvider.autoDispose<String>((ref) async {
  final expenses = await ref.watch(last60DaysProvider.future);
  
  if (expenses.isEmpty) {
    return 'Not enough data this month to generate an AI summary.';
  }

  // Filter for this month
  final now = DateTime.now();
  final thisMonth = expenses.where((e) => e.date.month == now.month && e.date.year == now.year).toList();
  
  if (thisMonth.isEmpty) {
    return 'You have no recorded spending this month. Start tracking to get insights!';
  }

  final summaryJson = jsonEncode(thisMonth.map((e) => {
    'title': e.title,
    'amount': e.amount,
    'category': e.category.name,
    'date': e.date.toIso8601String(),
  }).toList());

  final gemini = ref.watch(geminiDatasourceProvider);
  return gemini.generateMonthlySummary(summaryJson);
});

class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Monthly Spending Analysis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: summaryAsync.when(
                    data: (summary) => Text(
                      summary,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    loading: () => const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Gemini is analyzing your spending...'),
                      ],
                    ),
                    error: (err, _) => const Text(r'Error: $err'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // We could add more cards here for Budget Advice, Saving Tips, etc.
              ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text('Chat with SmartSpend AI'),
                onPressed: () {
                  context.push('/chat');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}