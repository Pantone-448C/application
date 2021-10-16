import 'package:application/pages/signup/cubit/signup_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _InputBox extends StatelessWidget {
  _InputBox(this.onChanged, this._labelText, {Key? key}) : super(key: key);

  String _labelText;
  var onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: TextField(
        onChanged: onChanged,
        decoration: inputDecoration(_labelText),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  /**
   * Navigate to the next page
   * TODO: Move all the verification logic somewhere else
   */
  void navigateNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Container()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: ListView(
          children: [
            Container(
              height: 200,
              width: 350,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Text(
                  "Tell us about yourself",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                return _InputBox(
                  (value) => context.read<SignupCubit>().emailChanged(value),
                  "Email address",
                );
              },
            ),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                return _InputBox(
                  (value) =>
                      context.read<SignupCubit>().firstNameChanged(value),
                  "First name",
                );
              },
            ),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                return _InputBox(
                  (value) => context.read<SignupCubit>().lastNameChanged(value),
                  "Last name",
                );
              },
            ),
            _NextButton(),
          ],
        ),
      ),
    );
  }
}

class SignupPasswordPage extends StatelessWidget {
  const SignupPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            width: 350,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: Text(
                "Enter a new password",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              return _InputBox(
                (value) => context.read<SignupCubit>().passwordChanged(value),
                "Password",
              );
            },
          ),
          BlocBuilder<SignupCubit, SignupState>(
            builder: (context, state) {
              return _InputBox(
                (value) =>
                    context.read<SignupCubit>().passwordConfirmChanged(value),
                "Confirm Password",
              );
            },
          ),
          _FinishButton(),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SignupCubit>(context);
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Center(
          child: Container(
            child: ElevatedButton(
              child: Text("Next", style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider<SignupCubit>.value(
                        value: bloc, child: SignupPasswordPage());
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FinishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Center(
          child: Container(
            child: ElevatedButton(
              child: Text("Create account", style: TextStyle(fontSize: 20)),
              onPressed: () {
                context.read<SignupCubit>().signupWithCredentials();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ),
        );
      },
    );
  }
}
