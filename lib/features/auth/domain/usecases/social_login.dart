import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

/// one very small generic use-case – we pass the provider key at call-time
@lazySingleton
class SocialLogin implements UseCase<User, String/*provider*/> {
  final AuthRepository _repo;
  SocialLogin(this._repo);

  @override
  Future<Either<Failure, User>> call(String provider) {
    switch (provider) {
      case 'google':
        return _repo.loginGoogle();
      case 'apple':
        return _repo.loginApple();
      case 'facebook':
        return _repo.loginFacebook();
      default:
        throw UnimplementedError('unknown provider $provider');
    }
  }
}
