import 'package:application/login/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'signup.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    //var logoHeight = 350.0;
    //if (MediaQuery.of(context).viewInsets.bottom > 0) {
    //  logoHeight = 0.0;
    //}
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          BlocProvider(
            create: (_) => LoginCubit(),
            child: LoginForm(),
          )
        ],
      ),
    );
  }
}


class LoginForm extends StatelessWidget {
  static const horizontalInset = 30.0;
  static const topInset = 50.0;
  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
      },
      child: Column(
        children: [
          Logo(),
          Padding(
            padding: EdgeInsets.only(
              top: topInset,
              left: horizontalInset,
              right: horizontalInset,
            ),
            child: _EmailInput(),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: horizontalInset,
                right: horizontalInset,
            ),
            child: _PasswordInput(),
          ),
          _LoginButton(),
        ],
      ),
    );
  }
}


InputDecoration inputDecoration(String label) {
  const roundedness = 10.0;
  return InputDecoration(
    border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(roundedness),
        )
    ),
    labelText: label,
    helperText: '',
  );
}


class Logo extends StatelessWidget {
  static const height = 200.0;
  static const fontSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Container(
          height: isKeyboardVisible ? 0 : height,
          alignment: Alignment.center,
          child: Text(
              "wanderlist",
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: fontSize,
              )
          ),
        );
      }
    );
  }
}


class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          onTap: () => context.read<LoginCubit>().selectInput(),
          onEditingComplete: () => context.read<LoginCubit>().deSelectInput(),
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration('Email'),
        );
      },
    );
  }
}
class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: inputDecoration('Password'),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: true
              ? () => context.read<LoginCubit>().logInWithCredentials()
              : null,
          child: const Text('LOGIN'),
        );
      },
    );
  }
}
