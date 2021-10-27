part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState({
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.password = "",
    this.passwordConfirm = "",
    this.signupError = "",
  });

  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String passwordConfirm;
  final String signupError;

  @override
  List<Object> get props =>
      [email, firstName, lastName, password, passwordConfirm, signupError];

  SignupState copyWith(
      {String? email,
      String? firstName,
      String? lastName,
      String? password,
      String? passwordConfirm,
      String? signupError}) {
    return SignupState(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      signupError: signupError ?? this.signupError,
    );
  }
}
