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
import 'features/auth/domain/usecases/check_auth_status.dart';
import 'features/auth/domain/usecases/login.dart' as auth_login;
import 'features/auth/domain/usecases/logout.dart' as auth_logout;
import 'features/auth/domain/usecases/register.dart' as auth_register;
import 'features/auth/domain/usecases/upload_profile_photo_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣  Initialise Firebase *before* DI needs it
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2️⃣  Now the singletons that ask for FirebaseAuth can be created safely
  await configureDependencies();

  final logger = getIt<LoggerService>()..i('Dependencies ready');

  // Crashlytics / analytics toggles
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // 3️⃣  Use the AuthBloc instance provided by get_it
  runApp(
    BlocProvider.value(
      value: getIt<AuthBloc>()..add(AuthStatusChecked()),
      child: const AppWidget(),
    ),
  );
}
