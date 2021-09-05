import 'package:application/login/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signup.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    var logoHeight = 350.0;
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      logoHeight = 0.0;
    }
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
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
      },
      child: Column(
        children: [
          _EmailInput(),
          _PasswordInput(),
          _LoginButton(),
        ],
      ),
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
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
          ),
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
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
          ),
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
