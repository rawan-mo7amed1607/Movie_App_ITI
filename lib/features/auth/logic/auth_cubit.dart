import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitialState());

  void register(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final userCredential = await authService.signUp(email: email, password: password);
      if (userCredential.user != null) {
        emit(AuthSuccessState(userCredential.user!));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final userCredential = await authService.signIn(email: email, password: password);
      if (userCredential.user != null) {
        emit(AuthSuccessState(userCredential.user!));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void logout() async {
    await authService.signOut();
    emit(UnauthenticatedState());
  }
}