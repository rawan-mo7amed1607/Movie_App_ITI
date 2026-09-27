import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  Future<UserCredential> login({
    required String email,
    required String pass,
  }) async {
    return _auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<UserCredential> signup({
    required String email,
    required String pass,
  }) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}