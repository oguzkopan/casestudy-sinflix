import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/failure.dart';
import 'package:sin_flix/core/usecases/usecase.dart';
import 'package:sin_flix/features/auth/domain/entities/user.dart';
import 'package:sin_flix/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class UploadProfilePhotoUsecase implements UseCase<User, UploadProfilePhotoParams> {
  final AuthRepository repository;

  UploadProfilePhotoUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(UploadProfilePhotoParams params) async {
    return await repository.uploadProfilePhoto(params.imageFile);
  }
}

class UploadProfilePhotoParams extends Equatable {
  final File imageFile;

  const UploadProfilePhotoParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}