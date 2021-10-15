import 'package:application/apptheme.dart';
import 'package:application/profile/cubit/profile_cubit.dart';
import 'package:application/profile/cubit/profile_state.dart';
import 'package:application/repositories/user/good_user_repository.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:application/titlebar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _UserPhoto extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (prev, next) => true,
        builder: (context, state) {
          if (state is ProfileInitial) {
            return CircularProgressIndicator();
          } else if (state is ProfileLoaded) {
            return Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(state.imgUrl),
                ),
              ),
            );
          } else {
            return Container(child: Text("Error"));
          }
        });
  }
}

class _UserInfo extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, next) => true,
      builder: (context, state) {
        if (state is ProfileInitial) {
          return CircularProgressIndicator();
        } else if (state is ProfileLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${state.firstName} ${state.lastName}",
                style: TextStyle(
                  fontFamily: "inter",
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              Text(
                "Points: ${state.points}",
                style: TextStyle(
                  fontFamily: "inter",
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ],
          );
        } else {
          return Container(child: Text("Error!"));
        }
      },
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            _UserPhoto(),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: _UserInfo(),
            ),
          ],
        ));
  }
}

class _LogoutButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
      child: Text(
        "Log out",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "inter",
        ),
      ),
    );
  }
}

class _RewardsSummary extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Your rewards"),
    ]);
  }
}

class ProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(GoodUserRepository()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          child: Column(
            children: [
              _UserInfoContainer(),
              _RewardsSummary(),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
