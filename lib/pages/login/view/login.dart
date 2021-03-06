import 'package:application/components/apptheme.dart';
import 'package:application/pages/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../signup/view/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  static const horizontalInset = 30.0;
  static const topInset = 50.0;

  LoginForm({Key? key}) : super(key: key);

  void showError(BuildContext context, String reason) {
    String heading, body;
    if (reason == "user-not-found") {
      heading = "Couldn't log in";
      body = "No user found with that email address";
    } else if (reason == "wrong-password") {
      heading = "Couldn't log in";
      body = "Invalid password";
    } else {
      heading = "Couldn't log in";
      body = "Invalid username or password";
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(heading),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.failReason != "") {
          showError(context, state.failReason);
        }
      },
      child: ListView(
        children: [
          Logo(),
          Padding(
            padding: EdgeInsets.only(
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
          _SignupButton(),
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
    )),
    labelText: label,
    helperText: '',
  );
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var logoHeight = 0.33 * MediaQuery.of(context).size.height;
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        height: logoHeight,
        alignment: Alignment.center,
        child: Text(
          "wanderlist",
          style: WanTheme.text.logo,
        ),
      );
    });
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
        return Center(
          child: Container(
            child: ElevatedButton(
              child: Text("Sign In", style: TextStyle(fontSize: 20)),
              onPressed: () =>
                  context.read<LoginCubit>().logInWithCredentials(),
            ),
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.only(
          left: 100,
          right: 100,
        ),
        child: TextButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ));
          },
          child: Text(
            "Sign up",
            style: WanTheme.text.signupButton,
          ),
        ),
      );
    });
  }
}
