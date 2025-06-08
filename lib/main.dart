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
import 'features/home/presentation/cubit/liked_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();

  final logger = getIt<LoggerService>()..i('Dependencies ready');
  Bloc.observer = AppBlocObserver(logger: logger);

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  runApp(
    MultiBlocProvider(
      providers: [
        // 👉 just expose the bloc – no initial event here
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider.value(value: getIt<LikedCubit>()),
      ],
      child: const AppWidget(),
    ),
  );
}

