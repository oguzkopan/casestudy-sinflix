import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/app/app_bloc_observer.dart';
import 'package:sin_flix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sin_flix/app/app_widget.dart';
import 'package:sin_flix/core/di/injector.dart';
import 'package:sin_flix/firebase_options.dart';
import 'core/services/logger_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣  Initialise Firebase before any singleton needs it
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2️⃣  Build the DI graph (now safe because Firebase is ready)
  await configureDependencies();

  final logger = getIt<LoggerService>()..i('Dependencies ready');

  // 🔸 Use the logger inside the global Bloc observer
  Bloc.observer = AppBlocObserver(logger: logger);

  // Optional: disable Crashlytics in debug
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // 3️⃣  Start the app with the singleton AuthBloc
  runApp(
    BlocProvider.value(
      value: getIt<AuthBloc>()..add(AuthStatusChecked()),
      child: const AppWidget(),
    ),
  );
}
