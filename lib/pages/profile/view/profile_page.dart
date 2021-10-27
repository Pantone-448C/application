import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/pages/profile/cubit/profile_cubit.dart';
import 'package:application/pages/profile/cubit/profile_state.dart';
import 'package:application/pages/rewards/view/reward_list.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _UserPhoto extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, next) => true,
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Container(
            height: 180,
            width: 144,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                  Radius.circular(WanTheme.CARD_CORNER_RADIUS)),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(state.imgUrl),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _ActivityHistoryPage extends StatelessWidget {
  final List<ActivityDetails> activities;

  const _ActivityHistoryPage(this.activities);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Activity History",
              style: TextStyle(color: WanTheme.colors.pink))),
      body: _ActivityHistoryList(activities),
    );
  }
}

class _ActivityHistoryList extends StatelessWidget {
  final List<ActivityDetails> activities;

  _ActivityHistoryList(List<ActivityDetails> this.activities);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(padding: EdgeInsets.all(8), children: [
      for (var activity in activities)
        Container(
            padding: EdgeInsets.only(bottom: 8),
            child: ActivitySummaryItemSmall(activity: activity))
    ]));
  }
}

class _UserInfo extends StatelessWidget {
  _UserInfo(this.firstName, this.lastName, this.points, this.user);

  final UserDetails user;
  final String firstName;
  final String lastName;
  final int points;

  Widget _name(String firstName, String lastName) {
    return Text(
      "$firstName $lastName",
      style: TextStyle(
        fontFamily: "inter",
        fontSize: 28,
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
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    _ActivityHistoryPage(user.completedActivities))),
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
            Container(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 8.0)),
                _name(firstName, lastName),
                _bigSmallText(context, "$points", "points"),
                _bigSmallText(context, "12", "completed activities"),
                Padding(padding: EdgeInsets.only(top: 18.0)),
                Row(children: [
                  _activityHistoryButton(context),
                  Container(width: 8),
                  _LogoutButton()
                ]),
              ],
            ));
  }
}

class _ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                    _UserInfo(state.firstName, state.lastName, state.points,
                        state.user),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Expanded(child: RewardsList()),
                ),
              ],
            ),
          );
        } else {
          return Container(child: Text("Error!"));
        }
      },
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  static final cardRadius = Radius.circular(WanTheme.CARD_CORNER_RADIUS);

  Material _buildInfoContainerWithChild(BuildContext context, Widget child) {
    return Material(
        child: Container(
      padding: EdgeInsets.all(8.0),
      child: child,
    ));
  }

  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, next) => true,
      builder: (context, state) {
        if (state is ProfileInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return _buildInfoContainerWithChild(
            context,
            Row(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                _UserInfo(
                    state.firstName, state.lastName, state.points, state.user),
              ],
            ),
          );
        } else {
          return Container(child: Text("Error!"));
        }
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 10, right: 0),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            WanTheme.colors.orange,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Log out  ",
              style: TextStyle(
                color: WanTheme.colors.white,
                fontFamily: "inter",
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.logout,
                )),
          ],
        ),
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
      title: Text("Profile", style: TextStyle(color: WanTheme.colors.pink)),
      // actions: [_settingsButton()],
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: WanTheme.colors.pink),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(RestUserRepository()),
      child: Scaffold(
        appBar: _profileAppBar(context),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          child: _ProfilePage(),
        ),
      ),
    );
  }
}
