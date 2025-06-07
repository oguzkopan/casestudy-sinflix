import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:sin_flix/core/services/logger_service.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/usecases/check_auth_status.dart';
import 'package:sin_flix/features/auth/domain/usecases/login.dart' as auth_login;
import 'package:sin_flix/features/auth/domain/usecases/logout.dart'
as auth_logout;
import 'package:sin_flix/features/auth/domain/usecases/register.dart'
as auth_register;
import 'package:sin_flix/features/auth/domain/usecases/upload_profile_photo_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth_login.Login _login;
  final auth_register.Register _register;
  final CheckAuthStatus _check;
  final auth_logout.Logout _logout;
  final UploadProfilePhotoUsecase _uploadPhoto;
  final LoggerService _log;

  AuthBloc(
      this._login,
      this._register,
      this._check,
      this._logout,
      this._uploadPhoto,
      this._log,
      ) : super(AuthInitial()) {
    on<AuthStatusChecked>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthPhotoUploadRequested>(_onUploadPhoto);
    on<AuthPhotoUploadSkipped>(_onSkipPhoto);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthUserUpdated>((e, emit) => emit(AuthAuthenticated(user: e.user)));
  }

  /* ------------------------------------------------------------------ */
  Future<void> _onCheck(
      AuthStatusChecked e, Emitter<AuthState> emit) async {
    _log.i('AuthBloc: checking status');
    emit(AuthLoading());
    final res = await _check(NoParams());
    res.fold(
          (f) => emit(AuthUnauthenticated()),
          (u) => emit(u == null ? AuthUnauthenticated() : AuthAuthenticated(user: u)),
    );
  }

  /* ------------------------------------------------------------------ */
  Future<void> _onLogin(
      AuthLoginRequested e, Emitter<AuthState> emit) async {
    _log.i('AuthBloc: login ${e.email}');
    emit(AuthLoading());
    final res =
    await _login(auth_login.LoginParams(email: e.email, password: e.password));
    res.fold(
          (f) => emit(AuthFailure(message: f.message)),
          (u) => emit(u.photoUrl == null || u.photoUrl!.isEmpty
          ? AuthNeedsPhotoUpload(user: u)
          : AuthAuthenticated(user: u)),
    );
  }

  /* ------------------------------------------------------------------ */
  Future<void> _onRegister(
      AuthRegisterRequested e, Emitter<AuthState> emit) async {
    _log.i('AuthBloc: register ${e.email}');
    emit(AuthLoading());
    final res = await _register(auth_register.RegisterParams(
        name: e.name,
        email: e.email,
        password: e.password,
        birthDate: e.birthDate));
    res.fold(
          (f) => emit(AuthFailure(message: f.message)),
          (u) => emit(AuthNeedsPhotoUpload(user: u)),
    );
  }

  /* ------------------------------------------------------------------ */
  Future<void> _onUploadPhoto(
      AuthPhotoUploadRequested e, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthNeedsPhotoUpload && current is! AuthAuthenticated) {
      _log.w('UploadPhoto in wrong state ${current.runtimeType}');
      return;
    }
    final user = current is AuthNeedsPhotoUpload
        ? current.user
        : (current as AuthAuthenticated).user;

    emit(AuthLoading());
    final res = await _uploadPhoto(UploadProfilePhotoParams(imageFile: e.imageFile));
    res.fold(
      /* ❌ upload failed → stay on add-photo */
          (f) {
        _log.e('upload failed: ${f.message}');
        emit(AuthNeedsPhotoUpload(user: user));
      },
      /* ✅ upload ok → home */
          (u) => emit(AuthAuthenticated(user: u)),
    );
  }

  /* ------------------------------------------------------------------ */
  void _onSkipPhoto(
      AuthPhotoUploadSkipped e, Emitter<AuthState> emit) {
    final current = state;
    if (current is AuthNeedsPhotoUpload) {
      emit(AuthAuthenticated(user: current.user));
    }
  }

  /* ------------------------------------------------------------------ */
  Future<void> _onLogout(
      AuthLogoutRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _logout(NoParams());
    emit(AuthUnauthenticated());
  }
}
