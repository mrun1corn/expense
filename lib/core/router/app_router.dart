import 'package:expense/features/ai_insights/presentation/screens/ai_chat_screen.dart';
import 'package:expense/features/ai_insights/presentation/screens/ai_insights_screen.dart';
import 'package:expense/features/auth/presentation/auth_provider.dart';
import 'package:expense/features/auth/presentation/login_screen.dart';
import 'package:expense/features/auth/presentation/profile_screen.dart';
import 'package:expense/features/expenses/domain/models/expense.dart';
import 'package:expense/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:expense/features/home/presentation/screens/main_shell_screen.dart';
import 'package:expense/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState.valueOrNull != null;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (isAuth && isGoingToLogin) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context: context,
          state: state,
          child: const MainShellScreen(),
        ),
      ),
      GoRoute(
        path: '/add',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const AddExpenseScreen(),
        ),
      ),
      GoRoute(
        path: '/expense/:id',
        pageBuilder: (context, state) {
          final expense = state.extra as Expense?;
          return _buildPageWithSlideTransition(
            context: context,
            state: state,
            child: AddExpenseScreen(existingExpense: expense),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/insights',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const AiInsightsScreen(),
        ),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const AiChatScreen(),
        ),
      ),
      GoRoute(
        path: '/settings/notifications',
        pageBuilder: (context, state) => _buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const NotificationSettingsScreen(),
        ),
      ),
    ],
  );
});

CustomTransitionPage _buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage _buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}