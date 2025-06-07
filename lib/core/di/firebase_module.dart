import 'package:firebase_auth/firebase_auth.dart' as fb;      // ← alias = fb
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  /// Provide a singleton FirebaseAuth via injectable
  @lazySingleton
  fb.FirebaseAuth get firebaseAuth => fb.FirebaseAuth.instance;

  /// Provide FirebaseStorage (for profile photos, etc.)
  @lazySingleton
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
}
