import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/exceptions.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/features/auth/data/datasources/auth_remote_data_source.dart';

import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _r;
  AuthRepositoryImpl(this._r);

  /* email / şifre */
  @override Future<Either<Failure, User>> login   (e, p) => _guard(() => _r.loginWithEmail(e, p));
  @override Future<Either<Failure, User>> register(n, e, p, b) =>
      _guard(() => _r.registerWithEmail(n, e, p, b));

  /* socials */
  @override Future<Either<Failure, User>> loginGoogle()   => _guard(_r.signInWithGoogle);
  @override Future<Either<Failure, User>> loginApple()    => _guard(_r.signInWithApple);
  @override Future<Either<Failure, User>> loginFacebook() => _guard(_r.signInWithFacebook);

  /* session */
  @override Future<Either<Failure, User?>> checkAuthStatus() => _guard(_r.currentUser);
  @override Future<Either<Failure, void>>   logout()         => _guard(_r.logout);

  /* avatar */
  @override Future<Either<Failure, User>> uploadProfilePhoto(File f) =>
      _guard(() => _r.uploadProfilePhoto(f));

  /* helper */
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() f) async {
    try { return Right(await f()); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(ServerFailure(e.toString())); }
  }
}
