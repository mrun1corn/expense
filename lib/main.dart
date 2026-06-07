import 'package:expense/core/db/isar_service.dart';
import 'package:expense/core/router/app_router.dart';
import 'package:expense/core/theme/app_theme.dart';
import 'package:expense/core/utils/notification_manager.dart';
import 'package:expense/features/settings/presentation/providers/settings_provider.dart';
import 'package:expense/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize Isar Local Database
  await IsarService.initialize();
  
  // Initialize Notifications
  await NotificationManager.init();
  await NotificationManager.initWorkmanager();

  runApp(
    const ProviderScope(
      child: SmartExpenseApp(),
    ),
  );
}

class SmartExpenseApp extends ConsumerWidget {
  const SmartExpenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Smart Expense Tracker',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      routerConfig: goRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
