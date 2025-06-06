import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class Logout implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  Logout(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.logout();
  }
}