import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase without crashing the app when it hasn't been
/// configured for this device/platform yet.
///
/// Neither source project this app was built from had Firebase wired up,
/// so this is new groundwork rather than a port of an existing working
/// implementation. Before this actually connects to a real project you
/// must run `flutterfire configure` (see FIREBASE_SETUP.md at the repo
/// root) to generate `lib/firebase_options.dart` and the native config
/// files (`google-services.json` / `GoogleService-Info.plist`).
///
/// Until that's done, [tryInitialize] fails quietly and
/// [FirebaseBootstrap.isReady] stays false — the rest of the app keeps
/// working against the local/offline backend in `services/local_db.dart`.
class FirebaseBootstrap {
  static bool isReady = false;

  static Future<void> tryInitialize() async {
    try {
      await Firebase.initializeApp();
      isReady = true;
    } catch (e) {
      isReady = false;
      if (kDebugMode) {
        // ignore: avoid_print
        print(
          'Firebase not initialized (this is expected until you run '
          '`flutterfire configure` — see FIREBASE_SETUP.md): $e',
        );
      }
    }
  }
}

/// Thin wrapper around FirebaseAuth + Firestore for the pieces of the app
/// that opt into a real backend once one is configured. Every method
/// throws a [StateError] if Firebase isn't ready yet, so callers should
/// check [FirebaseBootstrap.isReady] (or catch and fall back to
/// [LocalDb]) rather than assuming this always succeeds.
class FirebaseAuthService {
  FirebaseAuthService() {
    if (!FirebaseBootstrap.isReady) {
      throw StateError(
        'Firebase is not initialized. Run `flutterfire configure` first '
        '(see FIREBASE_SETUP.md), or use LocalDb for offline auth.',
      );
    }
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required Map<String, dynamic> profile,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _db.collection('users').doc(credential.user!.uid).set({
      ...profile,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return credential;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<Map<String, dynamic>?> fetchProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> signOut() => _auth.signOut();
}
