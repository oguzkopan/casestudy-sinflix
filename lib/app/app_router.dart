import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/core/services/logger_service.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sin_flix/features/auth/presentation/pages/login_page.dart';
import 'package:sin_flix/features/auth/presentation/pages/profile_photo_add_page.dart';
import 'package:sin_flix/features/auth/presentation/pages/register_page.dart';
import 'package:sin_flix/features/home/presentation/pages/home_page.dart';
import 'package:sin_flix/features/profile/presentation/pages/profile_page.dart';
import 'package:sin_flix/features/profile/presentation/pages/subscription_page.dart';
import 'package:sin_flix/features/shell/presentation/pages/shell_page.dart';
import 'package:sin_flix/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static const splashPath   = '/';
  static const loginPath    = '/login';
  static const registerPath = '/register';
  static const addPhotoPath = '/add-photo';
  static const subscriptionPath = '/subscription';

  static const homePath    = '/home';
  static const profilePath = '/profile';

  static final _rootNavKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: splashPath,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),

    redirect: (context, state) {
      final auth = getIt<AuthBloc>().state;
      getIt<LoggerService>().i(
        'Redirect  ${state.matchedLocation}  ->  ${auth.runtimeType}',
      );

      if (auth is AuthInitial || auth is AuthLoading) {
        return state.matchedLocation == splashPath ? null : splashPath;
      }

      if (auth is AuthAuthenticated) {
        if ({loginPath, registerPath, addPhotoPath, splashPath}
            .contains(state.matchedLocation)) {
          return homePath;
        }
        return null;
      }

      if (auth is AuthNeedsPhotoUpload) {
        return state.matchedLocation == addPhotoPath ? null : addPhotoPath;
      }

      if (state.matchedLocation != loginPath &&
          state.matchedLocation != registerPath) {
        return loginPath;
      }
      return null;
    },

    routes: [
      GoRoute(path: splashPath, builder: (_, __) => const SplashPage()),
      GoRoute(path: loginPath, builder: (_, __) => const LoginPage()),
      GoRoute(path: registerPath, builder: (_, __) => const RegisterPage()),
      GoRoute(path: addPhotoPath, builder: (_, __) => const ProfilePhotoAddPage()),
      GoRoute(path: subscriptionPath, builder: (_, __) => const SubscriptionPage()),

      ShellRoute(
        builder: (_, __, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: homePath,
            name: 'home',
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: profilePath,
            name: 'profile',
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
    ],
  );
}

/* notifies GoRouter when AuthBloc emits */
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
