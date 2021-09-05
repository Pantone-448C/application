import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
    ));
  }

  Future<void> logInWithCredentials() async {
    print(state.email);
    print(state.password);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
    } catch (_) {
    }
  }

}