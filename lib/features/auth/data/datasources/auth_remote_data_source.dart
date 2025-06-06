import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/api/api_client.dart';
import 'package:sin_flix/core/api/api_constants.dart';
import 'package:sin_flix/core/error/exceptions.dart';
import 'package:sin_flix/features/auth/data/models/login_request.dart';
import 'package:sin_flix/features/auth/data/models/login_response.dart';
import 'package:sin_flix/features/auth/data/models/register_request.dart';
import 'package:sin_flix/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
  Future<UserModel> getProfile();
  Future<UserModel> uploadProfilePhoto(String filePath);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ServerException(message: response.data?['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException(message: e.response?.data?['message'] ?? 'Invalid credentials');
      }
      throw ServerException(message: e.message ?? 'Network error during login');
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['user'] != null) {
          return UserModel.fromJson(response.data['user']);
        } else if (response.data != null) {
          return UserModel.fromJson(response.data);
        }
        throw ServerException(message: 'Registration successful but no user data returned.');
      } else {
        throw ServerException(message: response.data?['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error during registration');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.profile);
      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw UnauthenticatedException(message: 'Unauthorized');
      } else {
        throw ServerException(message: response.data?['message'] ?? 'Failed to fetch profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthenticatedException(message: 'Unauthorized');
      }
      throw ServerException(message: e.message ?? 'Network error fetching profile');
    }
  }
  @override
  Future<UserModel> uploadProfilePhoto(String filePath) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        ApiConstants.uploadPhoto,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException(message: response.data?['message'] ?? 'Photo upload failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error during photo upload');
    }
  }
}