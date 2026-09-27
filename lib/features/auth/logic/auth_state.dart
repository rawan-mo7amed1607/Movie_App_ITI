import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthSuccessState extends AuthState {
  final User user;
  AuthSuccessState(this.user);
}
class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
class UnauthenticatedState extends AuthState {}