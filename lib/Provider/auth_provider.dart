import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_counter_app/Service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _user != null;

  // MARK:- Log-In
  Future<void> login({required String email, required String pass}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final credential = await _authService.login(email: email, pass: pass);
      _user = credential.user;
    } on FirebaseAuthException catch (error) {
      _errorMessage = "$error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // MARK:- Sign-Up
  Future<void> signup({required String email, required String pass}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final credential = await _authService.signup(email: email, pass: pass);
      _user = credential.user;
    } on FirebaseAuthException catch (error) {
      _errorMessage = "$error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // MARK:- Log-Out
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.logout();
      _user = null;
    } on FirebaseAuthException catch (error) {
      _errorMessage = "$error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}