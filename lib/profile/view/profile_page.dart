import 'package:application/apptheme.dart';
import 'package:application/profile/cubit/profile_cubit.dart';
import 'package:application/profile/cubit/profile_state.dart';
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
  Widget _name(String firstName, String lastName) {
    return Text(
      "$firstName $lastName",
      style: TextStyle(
        fontFamily: "inter",
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  RichText _bigSmallText(BuildContext context, String big, String small) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: big,
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 18),
          ),
          TextSpan(
            text: " " + small,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ],
      ),
    );
  }

  Widget _activityHistoryButton(BuildContext context) {
    return Container(
      height: 30,
      width: 175,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 10, right: 0),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            WanTheme.colors.purple,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
              ),
            ),
          ),
        ),
        onPressed: () => {}, // TODO: make this go to the activity history page
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Archive History",
              style: TextStyle(
                fontFamily: "inter",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, next) => true,
      builder: (context, state) {
        if (state is ProfileInitial) {
          return CircularProgressIndicator();
        } else if (state is ProfileLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _name(state.firstName, state.lastName),
              Padding(padding: EdgeInsets.only(top: 6.0)),
              _bigSmallText(context, "${state.points}", "points"),
              _bigSmallText(context, "12", "completed activities"),
              Padding(padding: EdgeInsets.only(top: 16.0)),
              _activityHistoryButton(context),
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
    const cardRadius = Radius.circular(WanTheme.CARD_CORNER_RADIUS);

    return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            bottomLeft: cardRadius,
            bottomRight: cardRadius,
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            _UserPhoto(),
            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
            _UserInfo(),
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
      create: (_) => ProfileCubit(UserRepository()),
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
