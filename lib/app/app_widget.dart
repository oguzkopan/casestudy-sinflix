import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/core/theme/app_theme.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

import '../core/services/logger_service.dart';
// Import l10n generated file: import 'package:sin_flix/l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';


class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggerService>();
    logger.i("AppWidget: build() called.");
    return BlocProvider(
      create: (ctx) {
        logger.i("AppWidget: AuthBloc create() in BlocProvider - getting instance from GetIt.");
        final authBlocInstance = getIt<AuthBloc>();
        logger.i("AppWidget: AuthBloc instance hashCode: ${authBlocInstance.hashCode}");
        authBlocInstance.add(AuthStatusChecked());
        logger.i("AppWidget: AuthStatusChecked event ADDED.");
        return authBlocInstance;
      },
      child: MaterialApp.router(
        title: 'SinFlix',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}