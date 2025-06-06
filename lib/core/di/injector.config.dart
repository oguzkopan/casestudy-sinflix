// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/repositories/auth_repository_impl.dart'
    as _i132;
import '../../features/auth/domain/usecases/check_auth_status.dart' as _i643;
import '../../features/auth/domain/usecases/login.dart' as _i428;
import '../../features/auth/domain/usecases/logout.dart' as _i597;
import '../../features/auth/domain/usecases/register.dart' as _i480;
import '../../features/auth/domain/usecases/upload_profile_photo_usecase.dart'
    as _i1030;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../api/api_client.dart' as _i277;
import '../services/logger_service.dart' as _i141;
import '../services/storage_service.dart' as _i306;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i277.ApiClient>(() => _i277.ApiClient());
  gh.lazySingleton<_i141.LoggerService>(() => _i141.LoggerServiceImpl());
  gh.lazySingleton<_i306.StorageService>(() => _i306.SecureStorageService());
  gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(gh<_i277.ApiClient>()));
  gh.lazySingleton<_i787.AuthRepository>(() => _i132.AuthRepositoryImpl(
        gh<_i107.AuthRemoteDataSource>(),
        gh<_i306.StorageService>(),
      ));
  gh.lazySingleton<_i1030.UploadProfilePhotoUsecase>(
      () => _i1030.UploadProfilePhotoUsecase(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i428.Login>(() => _i428.Login(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i480.Register>(
      () => _i480.Register(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i643.CheckAuthStatus>(
      () => _i643.CheckAuthStatus(gh<_i787.AuthRepository>()));
  gh.lazySingleton<_i597.Logout>(
      () => _i597.Logout(gh<_i787.AuthRepository>()));
  gh.singleton<_i797.AuthBloc>(() => _i797.AuthBloc(
        gh<_i428.Login>(),
        gh<_i480.Register>(),
        gh<_i643.CheckAuthStatus>(),
        gh<_i597.Logout>(),
        gh<_i1030.UploadProfilePhotoUsecase>(),
        gh<_i141.LoggerService>(),
      ));
  return getIt;
}
