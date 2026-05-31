import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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

    // Keep controller updated if provider state changes asynchronously on load
    ref.listen<String>(apiKeyProvider, (previous, next) {
      if (_keyController.text != next) {
        _keyController.text = next;
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gemini API Key Config Card (Herness-style)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    Theme.of(context).colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Gemini AI Setup (Herness-Style)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To bypass Google OAuth sensitive scope blocks, you can enter your own personal Gemini API Key directly, just like in developer agents. Dynamic OAuth tokens will be bypassed.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  // Step-by-Step Tutorial Guide (Demo)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How to get your free key:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('Get Free API Key'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                      border: const OutlineInputBorder(),
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
                        child: const Text('Save Key'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Existing settings options
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Smart Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/settings/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile & Sync'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/profile');
            },
          ),
        ],
      ),
    );
  }
}