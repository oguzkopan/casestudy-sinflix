// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:injectable/injectable.dart';
import 'package:sin_flix/core/error/exceptions.dart';
import 'package:sin_flix/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /* e-mail / şifre */
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(
      String name, String email, String password, String birthDate);

  /* current user / logout */
  Future<UserModel?> currentUser();
  Future<void> logout();

  /* social providers */
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel> signInWithFacebook();

  /* avatar upload */
  Future<UserModel> uploadProfilePhoto(File file);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth  _auth;
  final FirebaseStorage  _storage;
  AuthRemoteDataSourceImpl(this._auth, this._storage);

  /* helpers -------------------------------------------------------------- */
  UserModel _mapFbUser(fb.User u) => UserModel(
    id: u.uid,
    name: u.displayName ?? '',
    email: u.email ?? '',
    photoUrl: u.photoURL,
  );

  /* e-mail / şifre ------------------------------------------------------- */
  @override
  Future<UserModel> loginWithEmail(String e, String p) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: e, password: p);
      return _mapFbUser(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase login failed');
    }
  }

  @override
  Future<UserModel> registerWithEmail(
      String n, String e, String p, String birth) async {
    try {
      final cred =
      await _auth.createUserWithEmailAndPassword(email: e, password: p);
      await cred.user!.updateDisplayName(n);
      return _mapFbUser(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase register failed');
    }
  }

  /* current user / logout ----------------------------------------------- */
  @override
  Future<UserModel?> currentUser() async =>
      _auth.currentUser == null ? null : _mapFbUser(_auth.currentUser!);

  @override
  Future<void> logout() => _auth.signOut();

  /* social sign-ins ------------------------------------------------------ */
  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw ServerException(message: 'Google aborted');
    final googleAuth = await googleUser.authentication;
    final cred = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final userCred = await _auth.signInWithCredential(cred);
    return _mapFbUser(userCred.user!);
  }

  @override
  Future<UserModel> signInWithApple() async {
    final apple = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
    final cred = fb.OAuthProvider('apple.com')
        .credential(idToken: apple.identityToken, accessToken: apple.authorizationCode);
    final userCred = await _auth.signInWithCredential(cred);
    return _mapFbUser(userCred.user!);
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    final res = await FacebookAuth.instance.login();
    if (res.status != LoginStatus.success) {
      throw ServerException(message: 'Facebook aborted');
    }
    final cred = fb.FacebookAuthProvider.credential(
      res.accessToken!.tokenString,
    );
    final userCred = await _auth.signInWithCredential(cred);
    return _mapFbUser(userCred.user!);
  }

  /* avatar upload -------------------------------------------------------- */
  @override
  Future<UserModel> uploadProfilePhoto(File file) async {
    final uid = _auth.currentUser!.uid;
    final ref = _storage.ref().child('profile_photos/$uid.jpg');

    // 🔸 wait until the upload *really* finishes
    await ref.putFile(file).whenComplete(() {});

    final url = await ref.getDownloadURL();

    await _auth.currentUser!.updatePhotoURL(url);
    return _mapFbUser(_auth.currentUser!);
  }
}
