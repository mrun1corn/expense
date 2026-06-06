import 'dart:io';
import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color bgBaseLight = Color(0xFFF7F7F7);
  static const Color bgSurfaceLight = Color(0xFFFFFFFF);
  static const Color bgSunkenLight = Color(0xFFEFEFEF);
  
  static const Color fgPrimaryLight = Color(0xFF111111);
  static const Color fgSecondaryLight = Color(0xFF6B6B6B);
  static const Color fgTertiaryLight = Color(0xFFABABAB);

  static const Color heroBgLight = Color(0xFF111111);
  static const Color heroFgLight = Color(0xFFFFFFFF);
  static const Color heroFgMutedLight = Color(0xFF9B9B9B);

  static const Color successLight = Color(0xFF16A34A);
  static const Color successBgLight = Color(0xFFDCFCE7);
  static const Color warningLight = Color(0xFFD97706);
  static const Color warningBgLight = Color(0xFFFEF3C7);
  static const Color dangerLight = Color(0xFFDC2626);
  static const Color dangerBgLight = Color(0xFFFEE2E2);
  static const Color infoLight = Color(0xFF2563EB);
  static const Color infoBgLight = Color(0xFFDBEAFE);

  static const Color brandPrimaryLight = Color(0xFF111111);
  static const Color brandAccentLight = Color(0xFFF0F0F0);

  // Dark Mode Colors
  static const Color bgBaseDark = Color(0xFF0F0F0F);
  static const Color bgSurfaceDark = Color(0xFF1C1C1C);
  static const Color bgSunkenDark = Color(0xFF141414);
  static const Color bgElevatedDark = Color(0xFF252525);

  static const Color fgPrimaryDark = Color(0xFFF2F2F2);
  static const Color fgSecondaryDark = Color(0xFF8C8C8C);
  static const Color fgTertiaryDark = Color(0xFF4A4A4A);

  static const Color heroBgDark = Color(0xFF2A2A2A);
  static const Color heroBgAltDark = Color(0xFFFFFFFF);
  static const Color heroFgDark = Color(0xFFFFFFFF);
  static const Color heroFgMutedDark = Color(0xFF8C8C8C);

  static const Color successDark = Color(0xFF22C55E);
  static const Color successBgDark = Color(0xFF14532D);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color warningBgDark = Color(0xFF78350F);
  static const Color dangerDark = Color(0xFFF87171);
  static const Color dangerBgDark = Color(0xFF7F1D1D);
  static const Color infoDark = Color(0xFF60A5FA);
  static const Color infoBgDark = Color(0xFF1E3A5F);

  static const Color brandPrimaryDark = Color(0xFFFFFFFF);
  static const Color brandFgDark = Color(0xFF111111);
  static const Color brandAccentDark = Color(0xFF2A2A2A);

  // Theme Helpers
  static Color getBgBase(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? bgBaseDark : bgBaseLight;

  static Color getBgSurface(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? bgSurfaceDark : bgSurfaceLight;

  static Color getBgSunken(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? bgSunkenDark : bgSunkenLight;

  static Color getBgElevated(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? bgElevatedDark : bgSurfaceLight;

  static Color getFgPrimary(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? fgPrimaryDark : fgPrimaryLight;

  static Color getFgSecondary(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? fgSecondaryDark : fgSecondaryLight;

  static Color getFgTertiary(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? fgTertiaryDark : fgTertiaryLight;

  static Color getHeroBg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? heroBgDark : heroBgLight;

  static Color getHeroFg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? heroFgDark : heroFgLight;

  static Color getHeroFgMuted(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? heroFgMutedDark : heroFgMutedLight;

  static Color getSuccess(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? successDark : successLight;

  static Color getSuccessBg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? successBgDark : successBgLight;

  static Color getWarning(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? warningDark : warningLight;

  static Color getWarningBg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? warningBgDark : warningBgLight;

  static Color getDanger(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? dangerDark : dangerLight;

  static Color getDangerBg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? dangerBgDark : dangerBgLight;

  static Color getInfo(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? infoDark : infoLight;

  static Color getInfoBg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? infoBgDark : infoBgLight;

  static Color getBrandPrimary(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? brandPrimaryDark : brandPrimaryLight;

  static Color getBrandAccent(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? brandAccentDark : brandAccentLight;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double doubleXl = 24;
  static const double tripleXl = 32;
  static const double quadXl = 48;
}

class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;
}

class AppShadows {
  static const List<BoxShadow> shadow1Light = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0A000000), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> shadow2Light = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 12),
    BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 4),
  ];
  static const List<BoxShadow> shadow3Light = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, -4), blurRadius: 24),
  ];

  static const List<BoxShadow> shadow1Dark = [
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 2),
  ];
  static const List<BoxShadow> shadow2Dark = [
    BoxShadow(color: Color(0x99000000), offset: Offset(0, 4), blurRadius: 16),
  ];
  static const List<BoxShadow> shadow3Dark = [
    BoxShadow(color: Color(0xCC000000), offset: Offset(0, -4), blurRadius: 32),
  ];

  static List<BoxShadow> getShadow1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadow1Dark : shadow1Light;

  static List<BoxShadow> getShadow2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadow2Dark : shadow2Light;

  static List<BoxShadow> getShadow3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadow3Dark : shadow3Light;

  static Border getBorder(BuildContext context, {double width = 1.0, Color? color}) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Border.all(color: color ?? const Color(0x0FFFFFFF), width: width);
    }
    return Border.all(color: color ?? Colors.transparent, width: 0);
  }

  static Decoration getCardDecoration(BuildContext context, {double radius = AppRadii.lg}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.bgSurfaceDark : AppColors.bgSurfaceLight,
      borderRadius: BorderRadius.circular(radius),
      border: isDark ? Border.all(color: const Color(0x0FFFFFFF)) : null,
      boxShadow: isDark ? shadow1Dark : shadow1Light,
    );
  }
}

class AppTextStyles {
  static String get _monoFont => Platform.isIOS ? 'Courier' : 'monospace';

  static TextStyle displayXl({required Color color}) => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.02 * 36,
      );

  static TextStyle displayLg({required Color color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.02 * 28,
      );

  static TextStyle displayMd({required Color color}) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.02 * 22,
      );

  static TextStyle headingLg({required Color color}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle headingMd({required Color color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headingSm({required Color color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyMd({required Color color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySm({required Color color}) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle caption({required Color color}) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle captionBold({required Color color}) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.02 * 11,
      );

  static TextStyle overline({required Color color}) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.06 * 10,
      );

  static TextStyle monospace(double size, {required Color color, FontWeight weight = FontWeight.w400}) => TextStyle(
        fontFamily: _monoFont,
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: -0.02 * size,
      );
}

class AppTheme {
  static ThemeData get light {
    final defaultTextTheme = ThemeData.light().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgBaseLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBaseLight,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.fgPrimaryLight),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.fgPrimaryLight),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandPrimaryLight,
        onSurface: AppColors.fgPrimaryLight,
        onSurfaceVariant: AppColors.fgSecondaryLight,
        outlineVariant: AppColors.bgSunkenLight,
      ),
      textTheme: defaultTextTheme.copyWith(
        displayLarge: AppTextStyles.displayXl(color: AppColors.fgPrimaryLight),
        displayMedium: AppTextStyles.displayLg(color: AppColors.fgPrimaryLight),
        displaySmall: AppTextStyles.displayMd(color: AppColors.fgPrimaryLight),
        titleLarge: AppTextStyles.headingLg(color: AppColors.fgPrimaryLight),
        titleMedium: AppTextStyles.headingMd(color: AppColors.fgPrimaryLight),
        titleSmall: AppTextStyles.headingSm(color: AppColors.fgPrimaryLight),
        bodyLarge: AppTextStyles.bodyMd(color: AppColors.fgPrimaryLight),
        bodyMedium: AppTextStyles.bodySm(color: AppColors.fgPrimaryLight),
        bodySmall: AppTextStyles.caption(color: AppColors.fgSecondaryLight),
      ),
    );
  }

  static ThemeData get dark {
    final defaultTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgBaseDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBaseDark,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.fgPrimaryDark),
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.fgPrimaryDark),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brandPrimaryDark,
        surface: AppColors.bgSurfaceDark,
        onSurface: AppColors.fgPrimaryDark,
        onSurfaceVariant: AppColors.fgSecondaryDark,
        outlineVariant: AppColors.bgSunkenDark,
      ),
      textTheme: defaultTextTheme.copyWith(
        displayLarge: AppTextStyles.displayXl(color: AppColors.fgPrimaryDark),
        displayMedium: AppTextStyles.displayLg(color: AppColors.fgPrimaryDark),
        displaySmall: AppTextStyles.displayMd(color: AppColors.fgPrimaryDark),
        titleLarge: AppTextStyles.headingLg(color: AppColors.fgPrimaryDark),
        titleMedium: AppTextStyles.headingMd(color: AppColors.fgPrimaryDark),
        titleSmall: AppTextStyles.headingSm(color: AppColors.fgPrimaryDark),
        bodyLarge: AppTextStyles.bodyMd(color: AppColors.fgPrimaryDark),
        bodyMedium: AppTextStyles.bodySm(color: AppColors.fgPrimaryDark),
        bodySmall: AppTextStyles.caption(color: AppColors.fgSecondaryDark),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.overline,
    this.action,
    this.showBackButton = false,
  });

  final String title;
  final String? subtitle;
  final String? overline;
  final Widget? action;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBackButton && Navigator.of(context).canPop()) ...[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.getFgPrimary(context),
                  size: 24,
                ),
              ),
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (overline != null) ...[
                  Text(
                    overline!.toUpperCase(),
                    style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  title,
                  style: AppTextStyles.headingLg(color: AppColors.getFgPrimary(context)).copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 16),
            action!,
          ],
        ],
      ),
    );
  }
}
