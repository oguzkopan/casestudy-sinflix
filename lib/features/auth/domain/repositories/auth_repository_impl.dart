import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/exceptions.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/services/storage_service.dart';
import 'package:sin_flix/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sin_flix/features/auth/data/models/login_request.dart';
import 'package:sin_flix/features/auth/data/models/register_request.dart';
import 'package:sin_flix/features/auth/data/models/user_model.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final loginResponse = await _remoteDataSource.login(request);
      await _storageService.saveToken(loginResponse.token);
      await _storageService.saveUser(loginResponse.user.toJsonString());
      return Right(loginResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network Error"));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password, String birthDate) async {
    try {
      final request = RegisterRequest(name: name, email: email, password: password, birthDate: birthDate);
      final userModel = await _remoteDataSource.register(request);
      final loginEither = await login(email, password);
      return loginEither.fold(
            (failure) => Left(failure),
            (user) => Right(user),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network Error"));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      final token = await _storageService.getToken();
      final userJson = await _storageService.getUser();

      if (token != null && token.isNotEmpty && userJson != null) {
        final userModel = UserModel.fromJsonString(userJson);
        try {
          final profileUser = await _remoteDataSource.getProfile();
          if (profileUser.id == userModel.id) { // Verify stored user with fresh profile data
            await _storageService.saveUser(profileUser.toJsonString()); // Update stored user
            return Right(profileUser);
          } else {
            await logout(); // Mismatch, clear session
            return const Right(null);
          }
        } on UnauthenticatedException {
          await logout();
          return const Right(null);
        } on ServerException {
          return Right(userModel); // Return cached user if profile check fails but token was valid
        }
      } else {
        await logout(); // Ensure everything is cleared if partial data exists
        return const Right(null);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network Error"));
    } catch (e) {
      await logout();
      return Left(CacheFailure("Error reading auth status: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _storageService.deleteToken();
      await _storageService.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to clear session: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> uploadProfilePhoto(File imageFile) async {
    try {
      final userModel = await _remoteDataSource.uploadProfilePhoto(imageFile.path);
      await _storageService.saveUser(userModel.toJsonString());
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network Error"));
    }
  }
}