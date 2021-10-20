part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = "",
    this.password = "",
    this.isKeyboardOpen = false,
    this.failReason = "",
    this.isLoading = false,
  });

  final String email;
  final String password;
  final bool isKeyboardOpen;
  final bool isLoading;
  final String failReason;

  @override
  List<Object> get props =>
      [email, password, isKeyboardOpen, failReason, isLoading];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isKeyboardOpen,
    String? failReason,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isKeyboardOpen: isKeyboardOpen ?? this.isKeyboardOpen,
      failReason: failReason ?? this.failReason,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
