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
            height: 180,
            width: 144,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(state.imgUrl),
              ),
            ),
          );
        } else {
          return Container(child: Text("Error"));
        }
      },
    );
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
                  color: Color(0xFF666666),
                ),
          ),
        ],
      ),
    );
  }

  Widget _activityHistoryButton(BuildContext context) {
    return Container(
      height: 36,
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
              "Activity History",
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
              Padding(padding: EdgeInsets.only(top: 0.0)),
              _bigSmallText(context, "${state.points}", "points"),
              _bigSmallText(context, "12", "completed activities"),
              Padding(padding: EdgeInsets.only(top: 18.0)),
              _activityHistoryButton(context),
              Padding(padding: EdgeInsets.only(top: 8.0)),
              _LogoutButton(),
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
      height: 205,
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
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 175,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 10, right: 0),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            WanTheme.colors.pink,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
              ),
            ),
          ),
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        child: Row(
          children: [
            Icon(
              Icons.logout,
            ),
            Text(
              "Log out",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "inter",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardsSummary extends StatelessWidget {
  RichText _title(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: Icon(
            Icons.emoji_events_outlined,
            color: WanTheme.colors.orange,
          ),
        ),
        TextSpan(
          text: "Rewards",
          style: Theme.of(context).textTheme.headline3,
        ),
      ]),
    );
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(context),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  Widget _settingsButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.settings, color: Colors.black54, size: 30),
    );
  }

  AppBar _profileAppBar(BuildContext context) {
    return AppBar(
      title: Text("Profile", style: Theme.of(context).textTheme.headline2),
      actions: [_settingsButton()],
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(UserRepository()),
      child: Scaffold(
        appBar: _profileAppBar(context),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserInfoContainer(),
              _RewardsSummary(),
            ],
          ),
        ),
      ),
    );
  }
}
