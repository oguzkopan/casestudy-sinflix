import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/services/logger_service.dart'; // Import LoggerService
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/usecases/check_auth_status.dart';
import 'package:sin_flix/features/auth/domain/usecases/login.dart' as auth_login;
import 'package:sin_flix/features/auth/domain/usecases/logout.dart' as auth_logout;
import 'package:sin_flix/features/auth/domain/usecases/register.dart' as auth_register;
import 'package:sin_flix/features/auth/domain/usecases/upload_profile_photo_usecase.dart';


part 'auth_event.dart';
part 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth_login.Login _loginUseCase;
  final auth_register.Register _registerUseCase;
  final CheckAuthStatus _checkAuthStatusUseCase;
  final auth_logout.Logout _logoutUseCase;
  final UploadProfilePhotoUsecase _uploadProfilePhotoUsecase;
  final LoggerService _logger; // Declare the logger instance variable

  AuthBloc(
      this._loginUseCase,
      this._registerUseCase,
      this._checkAuthStatusUseCase,
      this._logoutUseCase,
      this._uploadProfilePhotoUsecase,
      this._logger, // Inject LoggerService through the constructor
      ) : super(AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthPhotoUploadRequested>(_onPhotoUploadRequested);
    on<AuthPhotoUploadSkipped>(_onPhotoUploadSkipped);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthStatusChecked(AuthStatusChecked event, Emitter<AuthState> emit) async {
    _logger.i("AuthBloc (${this.hashCode}): _onAuthStatusChecked event RECEIVED."); // Add hashCode
    emit(AuthLoading());
    _logger.i("AuthBloc: Emitted AuthLoading.");
    final failureOrUser = await _checkAuthStatusUseCase(NoParams());
    failureOrUser.fold(
          (failure) {
        _logger.i("AuthBloc: CheckAuthStatus failed: ${failure.message}. Emitting AuthUnauthenticated.");
        emit(AuthUnauthenticated());
      },
          (user) {
        if (user != null) {
          _logger.i("AuthBloc: User found (ID: ${user.id}). Emitting AuthAuthenticated.");
          emit(AuthAuthenticated(user: user));
        } else {
          _logger.i("AuthBloc: No user found. Emitting AuthUnauthenticated.");
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    _logger.i("AuthBloc: Login requested for email: ${event.email}");
    emit(AuthLoading());
    final failureOrUser = await _loginUseCase(auth_login.LoginParams(email: event.email, password: event.password));
    failureOrUser.fold(
            (failure) {
          _logger.e("AuthBloc: Login failed: ${failure.message}");
          emit(AuthFailure(message: failure.message));
        },
            (user) {
          _logger.i("AuthBloc: Login successful for user (ID: ${user.id}). Emitting AuthAuthenticated.");
          emit(AuthAuthenticated(user: user));
        }
    );
  }

  Future<void> _onRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    _logger.i("AuthBloc: Register requested for email: ${event.email}");
    emit(AuthLoading());
    final failureOrUser = await _registerUseCase(auth_register.RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
      birthDate: event.birthDate,
    ));
    failureOrUser.fold(
            (failure) {
          _logger.e("AuthBloc: Registration failed: ${failure.message}");
          emit(AuthFailure(message: failure.message));
        },
            (user) {
          _logger.i("AuthBloc: Registration successful for user (ID: ${user.id}). Emitting AuthNeedsPhotoUpload.");
          emit(AuthNeedsPhotoUpload(user: user));
        }
    );
  }

  Future<void> _onPhotoUploadRequested(AuthPhotoUploadRequested event, Emitter<AuthState> emit) async {
    _logger.i("AuthBloc: Photo upload requested.");
    final currentState = state;
    if (currentState is AuthNeedsPhotoUpload || currentState is AuthAuthenticated) {
      User? currentUser;
      if (currentState is AuthNeedsPhotoUpload) currentUser = currentState.user;
      if (currentState is AuthAuthenticated) currentUser = currentState.user;

      if (currentUser == null) {
        _logger.e("AuthBloc: User context not found for photo upload.");
        emit(const AuthFailure(message: "User context not found for photo upload."));
        return;
      }

      emit(AuthLoading());
      _logger.i("AuthBloc: Uploading photo...");
      final failureOrUser = await _uploadProfilePhotoUsecase(UploadProfilePhotoParams(imageFile: event.imageFile));
      failureOrUser.fold(
              (failure) {
            _logger.e("AuthBloc: Photo upload failed: ${failure.message}");
            emit(AuthFailure(message: failure.message));
          },
              (updatedUser) {
            _logger.i("AuthBloc: Photo upload successful for user (ID: ${updatedUser.id}). Emitting AuthAuthenticated.");
            emit(AuthAuthenticated(user: updatedUser));
          }
      );
    } else {
      _logger.e("AuthBloc: Invalid state for photo upload. Current state: ${currentState.runtimeType}");
      emit(const AuthFailure(message: "Invalid state for photo upload."));
    }
  }

  void _onPhotoUploadSkipped(AuthPhotoUploadSkipped event, Emitter<AuthState> emit) {
    _logger.i("AuthBloc: Photo upload skipped.");
    if (state is AuthNeedsPhotoUpload) {
      final user = (state as AuthNeedsPhotoUpload).user;
      _logger.i("AuthBloc: Skipping photo upload for user (ID: ${user.id}). Emitting AuthAuthenticated.");
      emit(AuthAuthenticated(user: user));
    } else {
      _logger.w("AuthBloc: PhotoUploadSkipped called from unexpected state: ${state.runtimeType}. Re-checking auth status.");
      add(AuthStatusChecked());
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    _logger.i("AuthBloc: Logout requested.");
    emit(AuthLoading());
    final failureOrVoid = await _logoutUseCase(NoParams());
    failureOrVoid.fold(
            (failure) {
          _logger.e("AuthBloc: Logout failed: ${failure.message}");
          // Still emit Unauthenticated, but log the error
          emit(AuthUnauthenticated());
        },
            (_) {
          _logger.i("AuthBloc: Logout successful. Emitting AuthUnauthenticated.");
          emit(AuthUnauthenticated());
        }
    );
  }

  void _onAuthUserUpdated(AuthUserUpdated event, Emitter<AuthState> emit) {
    _logger.i("AuthBloc: User updated event received for user (ID: ${event.user.id}). Emitting AuthAuthenticated.");
    emit(AuthAuthenticated(user: event.user));
  }
}