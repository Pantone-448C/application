import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  void emailChanged(String value) async {
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

  void passwordConfirmChanged(String value) {
    emit(state.copyWith(
      passwordConfirm: value,
    ));
  }

  void lastNameChanged(String value) {
    emit(state.copyWith(
      lastName: value,
    ));
  }

  void firstNameChanged(String value) {
    emit(state.copyWith(
      firstName: value,
    ));
  }

  Future<bool> isEmailValid(String email) async {
    if (email == "") {
      return false;
    }
    try {
      var users = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return users.isEmpty;
    } catch (e) {
      return false;
    }

  }

  Future<String> signupWithCredentials() async {
    if (state.password != state.passwordConfirm) {
      return "Passwords don't match";
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      var users = FirebaseFirestore.instance.collection('users');
      users.doc(userCredential.user!.uid).set({
        'first_name': state.firstName,
        'last_name': state.lastName,
        'email': state.email,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return "";
    } catch (e) {
      print(e);
    }
  }
}
