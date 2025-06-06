import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sin_flix/core/services/logger_service.dart';

class AppBlocObserver extends BlocObserver {
  final LoggerService _logger;

  AppBlocObserver({required LoggerService logger}) : _logger = logger;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.i('onEvent -- ${bloc.runtimeType}, Event: ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.i('onChange -- ${bloc.runtimeType}, Change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.i('onTransition -- ${bloc.runtimeType}, Transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.e('onError -- ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i('onClose -- ${bloc.runtimeType}');
  }
}