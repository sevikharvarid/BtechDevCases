import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/common/state/view_state.dart';
import 'package:mobile/features/auth/presentation/screen/dashboard_screen.dart';
import 'package:mobile/features/auth/presentation/screen/login_screen.dart';
import 'package:mobile/features/auth/presentation/screen/register_screen.dart';
import 'package:mobile/features/auth/presentation/screen/splash_screen.dart';

import '../features/auth/presentation/bloc/auth_cubit.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter appRouter(BuildContext context) {
  final authCubit = context.read<AuthCubit>();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authCubit.state;

      final isAuthenticated = authState.authStatus.status == ViewState.success;

      final isLoggingIn = state.uri.toString().contains('/login');
      final isRegistering = state.uri.toString().contains('/register');
      final isSplash = state.uri.toString().contains('/splash');

      if (authState.authStatus.status == ViewState.loading ||
          authState.authStatus.status == ViewState.initial) {
        return isSplash ? null : '/splash';
      }

      if (isAuthenticated) {
        if (isLoggingIn || isRegistering) {
          return '/dashboard';
        }
        return null; 
      }

      if (!isLoggingIn && !isRegistering) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(), 
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.uri}'),
      ),
    ),
  );
}