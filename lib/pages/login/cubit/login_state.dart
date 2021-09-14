part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = "",
    this.password = "",
    this.isKeyboardOpen = false
  });

  final String email;
  final String password;
  final bool isKeyboardOpen;

  @override
  List<Object> get props => [email, password, isKeyboardOpen];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isKeyboardOpen,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isKeyboardOpen: isKeyboardOpen ?? this.isKeyboardOpen,
    );
  }
}