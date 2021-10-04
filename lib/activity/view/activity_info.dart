import 'package:application/activity/cubit/activity_cubit.dart';
import 'package:application/apptheme.dart';
import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/activity_repository.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "add_to.dart";

const _buttonSize = 40.0;
const _sectionSize1 = 75.0;
const _sectionSize2 = 125.0;
const _POINTSPADDING = 13.0;

class ActivityInfo extends StatelessWidget {
  ActivityInfo(this.id, {Key? key}) : super(key: key);

  final String id;

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCubit(ActivityRepository(), id),
      child: Scaffold(
        backgroundColor: WanTheme.colors.offWhite,
        body: ListView(
          children: [
            LocationImage(),
            Column(
              children: [
                _Title(),
                _PointsTooltip(),
              ],
            ),
            AboutBox(),
          ],
        ),
      ),
    );
  }
}

class LocationImage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocConsumer<ActivityCubit, ActivityState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ActivityLoaded) {
                return Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(state.imgUrl),
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width,
                );
              }
              return Container();
            }),
        Container(
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xCC000000),
                const Color(0x00000000),
                const Color(0x00000000),
                const Color(0xCC000000),
              ],
            ),
          ),
        ),
        _BackButton(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: WanColors().bgOrange,
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
              bottomRight: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
            ),
            child: Stack(children: <Widget>[
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(child: _Details(), flex: 70),
                    Expanded(child: FlagButton(), flex: 15),
                    Expanded(child: LocationButton(), flex: 15),
                  ],
                ),
              ),
            ])));
  }
}

class _Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(builder: (context, state) {
      if (state is ActivityLoaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(WanTheme.CARD_PADDING),
                child: Text(
                  state.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )),
            Container(
                padding: EdgeInsets.only(
                    left: WanTheme.CARD_PADDING, bottom: WanTheme.CARD_PADDING),
                child: Text(
                  state.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

class _PointsTooltip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
        bottomRight: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
      ),
      child: Container(
        color: WanTheme.colors.bgOrange,
        padding: EdgeInsets.only(
          top: _POINTSPADDING,
          bottom: _POINTSPADDING,
        ),
        child: Center(
          child: BlocConsumer<ActivityCubit, ActivityState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ActivityLoaded) {
                return RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'inter',
                      color: WanTheme.colors.orange,
                      fontSize: 17.0,
                    ),
                    children: [
                      TextSpan(text: "Earn "),
                      TextSpan(
                        text: "${state.points.toString()} points",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " from this activity")
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class FlagButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          color: WanTheme.colors.orange,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddActivityPage(context.read<ActivityCubit>().id),
                ),
              );
            },
            icon: Icon(Icons.outlined_flag_rounded),
            color: WanTheme.colors.white,
          ),
        ),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          color: WanTheme.colors.pink,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.place_rounded),
            color: WanTheme.colors.white,
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    return Padding(
      padding: EdgeInsets.all(size.w * 0.02),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_rounded),
        color: WanTheme.colors.white,
        iconSize: size.w * 0.09,
      ),
    );
  }
}

class AboutBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: Container(
          color: WanTheme.colors.white,
          padding:
              EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 90,
                    child: Text(
                      "About",
                      style: TextStyle(
                        fontFamily: "inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: IconButton(
                      iconSize: 20.0,
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              BlocConsumer<ActivityCubit, ActivityState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ActivityLoaded) {
                    return Text(
                      state.about,
                      style: TextStyle(fontSize: 16),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
