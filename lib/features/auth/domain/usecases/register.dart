import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class Register implements UseCase<User, RegisterParams> {
  final AuthRepository _repository;
  Register(this._repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await _repository.register(params.name, params.email, params.password, params.birthDate);
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String birthDate;
  const RegisterParams({required this.name, required this.email, required this.password, required this.birthDate});
  @override
  List<Object> get props => [name, email, password, birthDate];
}