import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sin_flix/features/auth/presentation/pages/login_page.dart';
import 'package:sin_flix/features/auth/presentation/pages/profile_photo_add_page.dart';
import 'package:sin_flix/features/auth/presentation/pages/register_page.dart';
import 'package:sin_flix/features/shell/presentation/pages/shell_page.dart';
import 'package:sin_flix/features/splash/presentation/pages/splash_page.dart';
import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/features/home/presentation/pages/home_page.dart';
import 'package:sin_flix/features/profile/presentation/pages/profile_page.dart';

import '../core/services/logger_service.dart';

class AppRouter {
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String addPhotoPath = '/add-photo';
  static const String shellPath = '/shell';
  static const String homePath = '/home'; // within shell
  static const String profilePath = '/profile'; // within shell

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splashPath,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authBloc = getIt<AuthBloc>(); // Or context.read<AuthBloc>() if AuthBlocProvider is above MaterialApp.router
      final authState = authBloc.state;
      final logger = getIt<LoggerService>();

      logger.i("AppRouter Redirect: Current route: ${state.matchedLocation}, AuthState: ${authState.runtimeType}");

      if (authState is AuthInitial || authState is AuthLoading) {
        logger.i("AppRouter Redirect: AuthState is Initial or Loading. Staying on splash or current: ${state.matchedLocation}");
        return state.matchedLocation == AppRouter.splashPath ? null : AppRouter.splashPath; // Go to splash if not already there
      }

      if (authState is AuthAuthenticated) {
        logger.i("AppRouter Redirect: AuthState is Authenticated. User: ${authState.user.id}");
        if (state.matchedLocation == AppRouter.loginPath ||
            state.matchedLocation == AppRouter.registerPath ||
            state.matchedLocation == AppRouter.addPhotoPath ||
            state.matchedLocation == AppRouter.splashPath) {
          logger.i("AppRouter Redirect: Redirecting to Shell (Home).");
          return AppRouter.shellPath + AppRouter.homePath;
        }
        logger.i("AppRouter Redirect: Authenticated, already on a valid path or staying. No redirect.");
        return null; // Already on a good path or shell handles it
      }

      if (authState is AuthNeedsPhotoUpload) {
        logger.i("AppRouter Redirect: AuthState is NeedsPhotoUpload. User: ${authState.user.id}");
        if (state.matchedLocation != AppRouter.addPhotoPath) {
          logger.i("AppRouter Redirect: Redirecting to AddPhotoPath.");
          return AppRouter.addPhotoPath;
        }
        logger.i("AppRouter Redirect: NeedsPhotoUpload, already on add photo. No redirect.");
        return null;
      }

      // Default to login for AuthUnauthenticated or AuthFailure
      logger.i("AppRouter Redirect: AuthState is Unauthenticated or Failure. Current: ${state.matchedLocation}");
      if (state.matchedLocation != AppRouter.loginPath && state.matchedLocation != AppRouter.registerPath) {
        logger.i("AppRouter Redirect: Redirecting to LoginPath.");
        return AppRouter.loginPath;
      }
      logger.i("AppRouter Redirect: Unauthenticated, already on login/register. No redirect.");
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: addPhotoPath,
        builder: (context, state) => const ProfilePhotoAddPage(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'shell'), // Add this key
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: AppRouter.homePath, // Remove shellPath prefix here
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: AppRouter.profilePath, // Remove shellPath prefix here
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    print("GoRouterRefreshStream: CONSTRUCTOR - Subscribing to stream: ${stream.hashCode}");
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
            (dynamic newState) {
          print("GoRouterRefreshStream: Stream emitted new state: ${newState.runtimeType}. Notifying listeners.");
          notifyListeners();
        },
        onError: (dynamic error) {
          print("GoRouterRefreshStream: Stream error: $error");
        },
        onDone: () {
          print("GoRouterRefreshStream: Stream done.");
        }
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}