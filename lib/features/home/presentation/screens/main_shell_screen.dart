import 'package:expense/features/ai_insights/presentation/screens/ai_insights_screen.dart';
import 'package:expense/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/expenses/presentation/screens/home_screen.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:expense/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const AiInsightsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final hasApiKey = ref.watch(apiKeyProvider).isNotEmpty;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: !isAuthenticated && !hasApiKey,
              label: const Icon(
                Icons.lock,
                size: 10,
                color: Colors.white,
              ),
              child: const Icon(Icons.auto_awesome_outlined),
            ),
            selectedIcon: const Icon(Icons.auto_awesome),
            label: 'AI Insights',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
