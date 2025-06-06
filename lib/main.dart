import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/app/app_bloc_observer.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sin_flix/app/app_widget.dart';
import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/firebase_options.dart';

import 'core/services/logger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Direct instantiation for early logging
  final earlyLogger = LoggerServiceImpl();
  earlyLogger.i("Main: App starting...");

  await configureDependencies();
  final logger = getIt<LoggerService>(); // Now use the injected one
  logger.i("Main: configureDependencies complete.");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i("Main: Firebase.initializeApp complete.");
  } catch (e, s) {
    logger.e("Main: Firebase.initializeApp FAILED", error: e, stackTrace: s);
  }

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    // ... release Crashlytics setup ...
  }
  logger.i("Main: Crashlytics setup complete.");

  Bloc.observer = AppBlocObserver(logger: logger);
  logger.i("Main: Bloc.observer set.");

  final authRepository = getIt<AuthRepository>();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository)..add(CheckAuthStatus()),
      child: const AppWidget(),
    ),
  );
  logger.i("Main: runApp executed.");
}