import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class CheckAuthStatus implements UseCase<User?, NoParams> {
  final AuthRepository _repository;
  CheckAuthStatus(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await _repository.checkAuthStatus();
  }
}