import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
    ));
  }

  void selectInput() {
    emit(state.copyWith(
      isKeyboardOpen: true,
    ));
  }

  void deSelectInput() {
    emit(state.copyWith(
      isKeyboardOpen: false,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
    ));
  }

  Future<void> logInWithCredentials() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(failReason: e.code));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(failReason: e.code));
      } else {
        emit(state.copyWith(failReason: e.code));
      }
    }
    emit(state.copyWith(failReason: ""));
  }
}
