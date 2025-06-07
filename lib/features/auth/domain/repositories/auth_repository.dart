import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
      String name, String email, String password, String birthDate);
  Future<Either<Failure, User?>> checkAuthStatus();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> uploadProfilePhoto(File file);

  /* optional: socials */
  Future<Either<Failure, User>> loginGoogle();
  Future<Either<Failure, User>> loginApple();
  Future<Either<Failure, User>> loginFacebook();
}