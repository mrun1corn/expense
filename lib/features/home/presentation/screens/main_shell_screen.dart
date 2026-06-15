import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/core/utils/notification_manager.dart';
import 'package:expense/features/ai_insights/presentation/screens/ai_insights_screen.dart';
import 'package:expense/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:expense/features/expenses/presentation/screens/home_screen.dart';
import 'package:expense/features/settings/presentation/providers/api_key_provider.dart';
import 'package:expense/features/settings/presentation/screens/settings_screen.dart';
import 'package:expense/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shellTabIndexProvider = StateProvider<int>((ref) => 0);

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermission();
    });
  }

  Future<void> _requestNotificationPermission() async {
    await NotificationManager.requestPermission();
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const AddExpenseScreen(),
    const AiInsightsScreen(),
    const SettingsScreen(),
  ];

  Widget _buildNavItem({
    required int index,
    required IconData outlineIcon,
    required IconData filledIcon,
    required String label,
    required int currentIndex,
    Widget? badge,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = AppColors.getBrandPrimary(context);
    final inactiveColor = AppColors.getFgTertiary(context);

    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(shellTabIndexProvider.notifier).state = index;
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (badge != null)
              Badge(
                label: badge,
                child: Icon(
                  isSelected ? filledIcon : outlineIcon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 20,
                ),
              )
            else
              Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? activeColor : inactiveColor,
                size: 20,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.captionBold(
                color: isSelected ? activeColor : inactiveColor,
              ).copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasApiKey = ref.watch(apiKeyProvider).isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = ref.watch(shellTabIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 80 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColors.getBgSurface(context),
          border: isDark
              ? const Border(
                  top: BorderSide(
                    color: Color(0x12FFFFFF),
                  ),
                )
              : const Border(
                  top: BorderSide(
                    color: Color(0x0F000000),
                  ),
                ),
          boxShadow: AppShadows.getShadow1(context),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              outlineIcon: Icons.home_outlined,
              filledIcon: Icons.home,
              label: 'Home',
              currentIndex: currentIndex,
            ),
            _buildNavItem(
              index: 1,
              outlineIcon: Icons.bar_chart_outlined,
              filledIcon: Icons.bar_chart,
              label: 'Stats',
              currentIndex: currentIndex,
            ),
            _buildNavItem(
              index: 2,
              outlineIcon: Icons.add_circle_outline_rounded,
              filledIcon: Icons.add_circle_rounded,
              label: 'Add',
              currentIndex: currentIndex,
            ),
            _buildNavItem(
              index: 3,
              outlineIcon: Icons.auto_awesome_outlined,
              filledIcon: Icons.auto_awesome,
              label: 'Insights',
              currentIndex: currentIndex,
              badge: !hasApiKey
                  ? const Icon(
                      Icons.lock,
                      size: 10,
                      color: Colors.white,
                    )
                  : null,
            ),
            _buildNavItem(
              index: 4,
              outlineIcon: Icons.settings_outlined,
              filledIcon: Icons.settings,
              label: 'Settings',
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}
