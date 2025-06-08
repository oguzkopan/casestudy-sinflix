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
  /* ---------- route paths ---------- */
  static const splashPath       = '/';
  static const loginPath        = '/login';
  static const registerPath     = '/register';
  static const addPhotoPath     = '/add-photo';
  static const subscriptionPath = '/subscription';

  static const homePath    = '/home';
  static const profilePath = '/profile';

  /* ---------- router ---------- */
  static final _rootKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey     : _rootKey,
    initialLocation  : splashPath,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),

    /* ---------- central redirect logic ---------- */
    redirect: (context, state) {
      final auth = getIt<AuthBloc>().state;
      getIt<LoggerService>()
          .i('Redirect  ${state.matchedLocation}  ->  ${auth.runtimeType}');

      /* ── 1. LAUNCH / WAITING ───────────────────────────────────────── */
      if (auth is AuthInitial) {
        // first launch → always stay on the splash logo
        return state.matchedLocation == splashPath ? null : splashPath;
      }
      if (auth is AuthLoading) {
        // let the current page render its own <Spinner/>
        return null;
      }

      /* ── 2. SIGNED-IN & READY ─────────────────────────────────────── */
      if (auth is AuthAuthenticated) {
        if ({loginPath, registerPath, addPhotoPath, splashPath}
            .contains(state.matchedLocation)) {
          return homePath;
        }
        return null; // already on an in-app page → stay
      }

      /* ── 3. USER NEEDS TO UPLOAD AN AVATAR ────────────────────────── */
      if (auth is AuthNeedsPhotoUpload) {
        return state.matchedLocation == addPhotoPath ? null : addPhotoPath;
      }

      /* ── 4. SIGN-OUT OR UNKNOWN ───────────────────────────────────── */
      if (state.matchedLocation != loginPath &&
          state.matchedLocation != registerPath) {
        return loginPath;
      }
      return null;
    },

    /* ---------- route table ---------- */
    routes: [
      GoRoute(path: splashPath   , builder: (_, __) => const SplashPage()),
      GoRoute(path: loginPath    , builder: (_, __) => const LoginPage()),
      GoRoute(path: registerPath , builder: (_, __) => const RegisterPage()),
      GoRoute(path: addPhotoPath , builder: (_, __) => const ProfilePhotoAddPage()),
      GoRoute(path: subscriptionPath,
          builder: (_, __) => const SubscriptionPage()),

      /* main shell with bottom navigation -------------------------------- */
      ShellRoute(
        builder: (_, __, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path       : homePath,
            name       : 'home',
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path       : profilePath,
            name       : 'profile',
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
    ],
  );
}

/* ────────────────────────────────────────────────────────────── */
/* helper that tells GoRouter to refresh when AuthBloc changes   */
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
