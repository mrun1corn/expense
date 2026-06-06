import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/presentation/providers/expense_provider.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _keyController;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController();
    // Initialize controller with current stored key after build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyController.text = ref.read(apiKeyProvider);
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedKey = ref.watch(apiKeyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<String>(apiKeyProvider, (previous, next) {
      if (_keyController.text != next) {
        _keyController.text = next;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Gemini API Key Config Card
          Container(
            decoration: AppShadows.getCardDecoration(context),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.getInfo(context),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gemini AI Setup',
                      style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock powerful AI features like auto-categorization, monthly summaries, and budget advice. Enter your personal Gemini API key below to get started. Your key is stored securely on your device.',
                  style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)).copyWith(height: 1.3),
                ),
                const SizedBox(height: 12),
                
                // Step Tutorial Guide
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getBgSunken(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0x12FFFFFF) : const Color(0x0F000000),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to get your free key:',
                        style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                      ),
                      const SizedBox(height: 8),
                      _buildStepItem('1', 'Tap "Get Free API Key" to open Google AI Studio.'),
                      _buildStepItem('2', 'Tap "Create API Key" & choose/create a project.'),
                      _buildStepItem('3', 'Copy the generated key (starts with AIzaSy...).'),
                      _buildStepItem('4', 'Paste the key in the field below and tap "Save Key".'),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final url = Uri.parse('https://aistudio.google.com/');
                            try {
                              final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
                              if (!launched) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not open browser. Please visit aistudio.google.com manually.')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open browser. Please visit aistudio.google.com manually.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new, size: 14),
                          label: const Text('Get Free API Key'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getBrandPrimary(context),
                            foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _keyController,
                  obscureText: _obscureKey,
                  decoration: InputDecoration(
                    labelText: 'Gemini API Key',
                    hintText: 'Enter AIzaSy... key',
                    filled: true,
                    fillColor: AppColors.getBgSunken(context),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.getBrandPrimary(context), width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureKey ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureKey = !_obscureKey;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (savedKey.isNotEmpty)
                      TextButton(
                        onPressed: () async {
                          await ref.read(apiKeyProvider.notifier).clearKey();
                          _keyController.clear();
                          final currentUser = ref.read(authStateProvider).valueOrNull;
                          if (currentUser != null) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.id)
                                  .set({'geminiApiKey': ''}, SetOptions(merge: true));
                            } catch (e) {
                              debugPrint('Failed to clear key in Firestore: $e');
                            }
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('API Key cleared successfully')),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.getDanger(context),
                        ),
                        child: const Text('Clear Key'),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final newKey = _keyController.text.trim();
                        if (newKey.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid key')),
                          );
                          return;
                        }
                        await ref.read(apiKeyProvider.notifier).setKey(newKey);
                        final currentUser = ref.read(authStateProvider).valueOrNull;
                        if (currentUser != null) {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser.id)
                                .set({'geminiApiKey': newKey}, SetOptions(merge: true));
                          } catch (e) {
                            debugPrint('Failed to save key in Firestore: $e');
                          }
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('API Key saved successfully')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getBrandPrimary(context),
                        foregroundColor: isDark ? AppColors.fgPrimaryLight : AppColors.heroFgLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save Key'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Theme Selector
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: Text(
                'Theme',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              trailing: DropdownButton<ThemeMode>(
                value: ref.watch(themeModeProvider),
                underline: const SizedBox(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    ref.read(themeModeProvider.notifier).setTheme(newValue);
                  }
                },
                items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>((value) {
                  return DropdownMenuItem<ThemeMode>(
                    value: value,
                    child: Text(
                      value.name.toUpperCase(),
                      style: AppTextStyles.bodySm(color: AppColors.getFgPrimary(context)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Currency Selector
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.attach_money_outlined),
              title: Text(
                'Currency',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              trailing: DropdownButton<String>(
                value: ref.watch(currencyProvider),
                underline: const SizedBox(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    ref.read(currencyProvider.notifier).setCurrency(newValue);
                  }
                },
                items: <String>['USD', 'EUR', 'GBP'].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyles.bodySm(color: AppColors.getFgPrimary(context)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Export CSV
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(
                'Export Data (CSV)',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              onTap: () async {
                final expensesAsync = ref.read(expensesStreamProvider);
                final expenses = expensesAsync.valueOrNull;
                if (expenses == null || expenses.isEmpty) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No data to export')),
                    );
                  }
                  return;
                }

                final rows = <List<dynamic>>[
                  ['ID', 'Title', 'Amount', 'Currency', 'Category', 'Date', 'Note']
                ];
                for (final exp in expenses) {
                  rows.add([
                    exp.id,
                    exp.title,
                    exp.amount,
                    exp.currency,
                    exp.category.name,
                    exp.date.toIso8601String(),
                    exp.note ?? ''
                  ]);
                }
                final csvString = Csv().encode(rows);
                final dir = await getTemporaryDirectory();
                final file = File('${dir.path}/expenses.csv');
                await file.writeAsString(csvString);
                
                if (context.mounted) {
                  final box = context.findRenderObject() as RenderBox?;
                  // ignore: deprecated_member_use
                  await Share.shareXFiles(
                    [XFile(file.path)],
                    text: 'My Expenses',
                    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                  );
                }
              },
            ),
          ),
          
          const SizedBox(height: 12),
          const Divider(height: 24, color: Colors.grey),
          const SizedBox(height: 12),
          
          // Existing settings options
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(
                'Smart Notifications',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/settings/notifications');
              },
            ),
          ),
          
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(
                'Profile & Sync',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}
