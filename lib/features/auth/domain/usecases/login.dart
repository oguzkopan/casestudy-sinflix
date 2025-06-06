import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class Login implements UseCase<User, LoginParams> {
  final AuthRepository _repository;
  Login(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await _repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}