import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Listen to Google Sign-In state controller errors
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication error: $error'),
              backgroundColor: AppColors.getDanger(context),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const _GuestProfileView();
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Stack(
                  children: [
                    if (user.photoUrl != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoUrl!),
                      )
                    else
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.getBgSunken(context),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.getFgSecondary(context),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                user.displayName,
                style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: AppTextStyles.bodyMd(color: AppColors.getFgSecondary(context)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getDanger(context),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  child: Text(
                    'Sign Out',
                    style: AppTextStyles.headingSm(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading profile: $e',
            style: AppTextStyles.bodyMd(color: AppColors.getDanger(context)),
          ),
        ),
      ),
    );
  }
}

class _GuestProfileView extends ConsumerWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: AppShadows.getCardDecoration(context, radius: 24),
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.getBrandAccent(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_sync_rounded,
                        size: 64,
                        color: AppColors.getBrandPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Secure Cloud Sync',
                      style: AppTextStyles.displayMd(color: AppColors.getFgPrimary(context)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Back up your data, sync settings, and manage personal keys across all your devices securely.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMd(color: AppColors.getFgSecondary(context)).copyWith(
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(
                      color: isDark ? const Color(0x12FFFFFF) : const Color(0x0F000000),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      context,
                      Icons.cloud_upload_rounded,
                      'Auto-Sync Expenses',
                      'Your local expenses sync to Firebase instantly.',
                    ),
                    _buildBenefitItem(
                      context,
                      Icons.key_rounded,
                      'API Key Portability',
                      'Restore your personal Gemini key on any device.',
                    ),
                    _buildBenefitItem(
                      context,
                      Icons.devices_rounded,
                      'Multi-Device Support',
                      'Access the same dashboard from Web, iOS, and Android.',
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.getBrandPrimary(context),
                          foregroundColor: isDark ? AppColors.brandFgDark : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    isDark ? AppColors.brandFgDark : Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login_rounded,
                                    color: isDark ? AppColors.brandFgDark : Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Sign In with Google',
                                    style: AppTextStyles.headingSm(
                                      color: isDark ? AppColors.brandFgDark : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.getBrandPrimary(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
