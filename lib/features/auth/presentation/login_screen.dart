import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: $error')),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.getBgSunken(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 80,
                    color: AppColors.getBrandPrimary(context),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'AI Expense Tracker',
                  style: AppTextStyles.displayLg(color: AppColors.getFgPrimary(context)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to sync your expenses and unlock AI insights.',
                  style: AppTextStyles.bodyMd(color: AppColors.getFgSecondary(context)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (authState.isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getBrandPrimary(context),
                            foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.login),
                          label: Text(
                            'Sign In with Google',
                            style: AppTextStyles.headingSm(
                              color: isDark ? AppColors.brandFgDark : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithGoogle();
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.getFgPrimary(context),
                            side: BorderSide(
                              color: isDark ? Colors.white24 : AppColors.getBrandPrimary(context),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Sign In with Test Account',
                            style: AppTextStyles.headingSm(
                              color: AppColors.getFgPrimary(context),
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithMock();
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.getFgSecondary(context),
                  ),
                  child: Text(
                    'Continue as Guest',
                    style: AppTextStyles.headingSm(color: AppColors.getFgSecondary(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
