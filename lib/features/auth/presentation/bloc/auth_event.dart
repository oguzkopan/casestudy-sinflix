part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String birthDate;
  const AuthRegisterRequested({required this.name, required this.email, required this.password, required this.birthDate});
  @override
  List<Object?> get props => [name, email, password, birthDate];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

class AuthPhotoUploadRequested extends AuthEvent {
  final File imageFile;
  const AuthPhotoUploadRequested({required this.imageFile});
  @override
  List<Object?> get props => [imageFile];
}

class AuthPhotoUploadSkipped extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final User user;
  const AuthUserUpdated(this.user);
  @override
  List<Object?> get props => [user];
}
