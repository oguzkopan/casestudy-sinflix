import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/app/app_router.dart';
import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/core/theme/app_theme.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';

import '../core/services/logger_service.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggerService>();
    logger.i("AppWidget: build() called.");
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: MaterialApp.router(
        title: 'SinFlix',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}