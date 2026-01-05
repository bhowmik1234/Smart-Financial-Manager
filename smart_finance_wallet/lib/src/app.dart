import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/authentication/presentation/auth_providers.dart';
import 'features/authentication/presentation/login_screen.dart';
import 'features/authentication/presentation/sign_up_screen.dart';
import 'features/authentication/presentation/forgot_password_screen.dart';
import 'features/transactions/presentation/wallet_dashboard_screen.dart';
import 'features/transactions/presentation/add_money_screen.dart';
import 'features/transactions/presentation/send_money_screen.dart';
import 'features/bnpl/presentation/bnpl_dashboard_screen.dart';
import 'features/rewards/presentation/rewards_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/notifications/presentation/notification_settings_screen.dart';
import 'core/theme/app_theme.dart';

import 'features/financial_intelligence/presentation/financial_insights_screen.dart';

class SmartFinanceApp extends ConsumerWidget {
  const SmartFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp.router(
      title: 'Smart Finance Wallet',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/sign-up',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletDashboardScreen(),
            routes: [
              GoRoute(
                path: 'add-money',
                builder: (context, state) => const AddMoneyScreen(),
              ),
              GoRoute(
                path: 'send-money',
                builder: (context, state) => const SendMoneyScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: '/bnpl',
            builder: (context, state) => const BnplDashboardScreen(),
          ),
          GoRoute(
            path: '/rewards',
            builder: (context, state) => const RewardsMarketplaceScreen(),
          ),
          GoRoute(
            path: '/financial-insights',
            builder: (context, state) => const FinancialInsightsScreen(),
          ),
          GoRoute(
            path: '/notification-settings',
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
        ],
        redirect: (context, state) {
          final isLoggedIn = authState.value != null;
          final isLoggingIn = state.uri.toString() == '/login';
          final isSigningUp = state.uri.toString() == '/sign-up';
          final isResettingPassword =
              state.uri.toString() == '/forgot-password';

          if (!isLoggedIn &&
              !isLoggingIn &&
              !isSigningUp &&
              !isResettingPassword) {
            return '/login';
          }

          if (isLoggedIn &&
              (isLoggingIn || isSigningUp || isResettingPassword)) {
            return '/';
          }

          return null;
        },
      ),
    );
  }
}
