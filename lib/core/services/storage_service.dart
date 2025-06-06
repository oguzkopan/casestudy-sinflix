import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class StorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(String userJson);
  Future<String?> getUser();
  Future<void> deleteUser();
}

@LazySingleton(as: StorageService)
class SecureStorageService implements StorageService {
  final _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_details';

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> saveUser(String userJson) async {
    await _secureStorage.write(key: _userKey, value: userJson);
  }

  @override
  Future<String?> getUser() async {
    return await _secureStorage.read(key: _userKey);
  }

  @override
  Future<void> deleteUser() async {
    await _secureStorage.delete(key: _userKey);
  }
}