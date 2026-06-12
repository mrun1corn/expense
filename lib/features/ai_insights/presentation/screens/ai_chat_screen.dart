import 'dart:async';
import 'dart:convert';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/ai_insights/data/local/isar/chat_message_isar.dart';
import 'package:expense/features/ai_insights/domain/models/chat_message.dart';
import 'package:expense/features/ai_insights/presentation/providers/gemini_provider.dart';
import 'package:expense/features/ai_insights/presentation/screens/ai_auth_fallback.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/notifications/engine/pattern_detector.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final isar = ref.watch(isarProvider);
  return ChatNotifier(isar);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier(this._isar) : super([]) {
    _loadMessages();
  }
  final Isar _isar;

  Future<void> _loadMessages() async {
    try {
      final messages = await _isar.chatMessageIsars
          .where()
          .sortByTimestamp()
          .findAll();
      state = messages.map((m) => m.toDomain()).toList();
    } catch (e) {
      debugPrint('Failed to load chat history: $e');
    }
  }

  Future<void> addMessage(ChatMessage message) async {
    state = [...state, message];
    try {
      await _isar.writeTxn(() async {
        await _isar.chatMessageIsars.put(ChatMessageIsar.fromDomain(message));
      });
    } catch (e) {
      debugPrint('Failed to save chat message: $e');
    }
  }

  Future<void> clearHistory() async {
    state = [];
    try {
      await _isar.writeTxn(() async {
        await _isar.chatMessageIsars.clear();
      });
    } catch (e) {
      debugPrint('Failed to clear chat history: $e');
    }
  }
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage([String? textToSend]) async {
    final text = (textToSend ?? _controller.text).trim();
    if (text.isEmpty) return;

    if (textToSend == null) {
      _controller.clear();
    }
    
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    await ref.read(chatMessagesProvider.notifier).addMessage(userMsg);
    _scrollToBottom();

    setState(() {
      _isLoading = true;
    });

    try {
      final gemini = ref.read(geminiDatasourceProvider);
      final history = ref.read(chatMessagesProvider);
      final expenses = ref.read(expensesStreamProvider).valueOrNull ?? [];
      final language = ref.read(localeProvider).languageCode;
      
      final responseStr = await gemini.sendChat(text, history, expenses, language);
      
      // Process potential database transactions from the bot reply
      final cleanResponse = await _processTransactionCommands(responseStr);
      
      final botMsg = ChatMessage(
        id: const Uuid().v4(),
        text: cleanResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      await ref.read(chatMessagesProvider.notifier).addMessage(botMsg);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMsg,
              style: AppTextStyles.bodySm(color: Colors.white),
            ),
            backgroundColor: AppColors.getDanger(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _processTransactionCommands(String text) async {
    final regExp = RegExp(r'\[ADD_TRANSACTION:\s*(.*?)\s*\]', dotAll: true);
    final match = regExp.firstMatch(text);
    if (match == null) return text;

    final jsonStr = match.group(1);
    if (jsonStr == null) return text;

    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      final title = (data['title'] as String?) ?? 'Chat Transaction';
      final categoryStr = (data['category'] as String?) ?? 'other';
      final typeStr = (data['type'] as String?) ?? 'expense';

      final category = ExpenseCategory.values.firstWhere(
        (c) => c.name == categoryStr,
        orElse: () => ExpenseCategory.other,
      );

      final type = TransactionType.values.firstWhere(
        (t) => t.name == typeStr,
        orElse: () => TransactionType.expense,
      );

      final currentUser = ref.read(authStateProvider).valueOrNull;
      final userId = currentUser?.id ?? '';

      final newExpense = Expense(
        id: const Uuid().v4(),
        userId: userId,
        amount: amount,
        currency: 'USD',
        category: category,
        date: DateTime.now(),
        title: title,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        note: 'Added via SmartSpend AI',
        type: type,
      );

      await ref.read(expenseRepositoryProvider).addExpense(newExpense);
      
      // Trigger background pattern detector
      PatternDetector.onExpenseAdded(newExpense);

      // Force refresh expense providers
      ref.invalidate(expensesStreamProvider);

      if (mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully recorded "$title" ($amount) under ${category.name.toUpperCase()}!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade800,
          ),
        );
      }

      // Return clean response without the technical command block tag
      return text.replaceAll(regExp, '').trim();
    } catch (e) {
      debugPrint('Failed to execute chat transaction command: $e');
      return text;
    }
  }

  Future<void> _confirmClearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History?'),
        content: const Text('Are you sure you want to delete all messages in this conversation?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(chatMessagesProvider.notifier).clearHistory();
    }
  }

  Widget _buildEmptyState() {
    final suggestedPrompts = [
      'How much did I spend this month?',
      'Add expense 15.50 for lunch',
      'Show my recent transactions',
      'Give me budget advice',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.getBrandAccent(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 64,
                color: AppColors.getBrandPrimary(context),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SmartSpend AI Advisor',
              style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me questions about your spending, get budget insights, or record new transactions directly in chat.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd(color: AppColors.getFgSecondary(context)).copyWith(
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Try asking:',
                style: AppTextStyles.headingSm(color: AppColors.getBrandPrimary(context)),
              ),
            ),
            const SizedBox(height: 10),
            ...suggestedPrompts.map((prompt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0x1FFFFFFF)
                              : const Color(0x1F000000),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _sendMessage(prompt),
                      child: Text(
                        prompt,
                        style: AppTextStyles.bodyMd(color: AppColors.getFgPrimary(context)).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasApiKey = ref.watch(apiKeyProvider).isNotEmpty;

    if (!hasApiKey) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SmartSpend AI'),
        ),
        body: const SafeArea(
          child: AiAuthFallback(
            title: 'Unlock SmartSpend AI',
            subtitle: 'Chat directly with your automated AI financial advisor about budgets, savings advice, and dynamic transaction history.',
          ),
        ),
      );
    }

    final messages = ref.watch(chatMessagesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartSpend AI'),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear Chat History',
              onPressed: _confirmClearChat,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isUser = msg.isUser;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isUser) ...[
                                Container(
                                  margin: const EdgeInsets.only(right: 8, top: 4),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.getBrandAccent(context),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: AppColors.getBrandPrimary(context),
                                  ),
                                ),
                              ],
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? AppColors.getBrandPrimary(context)
                                        : AppColors.getBgSunken(context),
                                    border: isUser
                                        ? null
                                        : (isDark
                                            ? Border.all(
                                                color: const Color(0x0FFFFFFF),
                                              )
                                            : null),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(18),
                                      topRight: const Radius.circular(18),
                                      bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                                    ),
                                  ),
                                  child: Text(
                                    msg.text,
                                    style: AppTextStyles.bodyMd(
                                      color: isUser
                                          ? (isDark ? AppColors.brandFgDark : Colors.white)
                                          : AppColors.getFgPrimary(context),
                                    ).copyWith(
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.getBrandAccent(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: AppColors.getBrandPrimary(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SmartSpend AI is thinking...',
                      style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.getBgSunken(context),
                        borderRadius: BorderRadius.circular(28),
                        border: isDark
                            ? Border.all(color: const Color(0x0FFFFFFF))
                            : null,
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask or say "add expense 5 coffee"...',
                          prefixIcon: Icon(
                            Icons.chat_bubble_outline,
                            color: AppColors.getFgSecondary(context),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                          hintStyle: AppTextStyles.bodyMd(color: AppColors.getFgTertiary(context)),
                        ),
                        style: AppTextStyles.bodyMd(color: AppColors.getFgPrimary(context)),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.getBrandPrimary(context),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: isDark ? AppColors.brandFgDark : Colors.white,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
