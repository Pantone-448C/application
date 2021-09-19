import 'package:application/apptheme.dart';
import 'package:application/sizeconfig.dart';
import 'package:flutter/material.dart';

const _buttonSize = 40.0;
const _sectionSize1 = 75.0;
const _sectionSize2 = 125.0;

class ActivityInfo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WanTheme.colors.offWhite,
      body: ListView(
        children: [
          LocationImage(),
          Stack(
            children: [
              _PointsTooltip(),
              _Title(),
            ],
          ),
          AboutBox(),
        ],
      ),
    );
  }
}

class LocationImage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          fit: BoxFit.cover,
          image: NetworkImage(
              "https://cdn.concreteplayground.com/content/uploads/2021/02/Otto-Brisbane_2021_04_supplied-1920x1440.jpg"),
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width,
        ),
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
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      child: Container(
        color: Colors.white,
        height: _sectionSize1,
        child: Row(
          children: [
            Expanded(child: _Details(), flex: 70),
            Expanded(child: FlagButton(), flex: 15),
            Expanded(child: LocationButton(), flex: 15),
          ],
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Tom's Kitchen",
          style: TextStyle(
            fontFamily: 'inter',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        Text("127 Queen Street, Brisbane",
            style: TextStyle(
              fontFamily: 'inter',
            ))
      ],
    );
  }
}

class _PointsTooltip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.only(top: _sectionSize1),
        height: _sectionSize2,
        color: WanTheme.colors.bgOrange,
        child: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'inter',
                color: WanTheme.colors.orange,
                fontSize: 17.0,
              ),
              children: [
                TextSpan(text: "Earn "),
                TextSpan(
                  text: "100 points",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " from this activity")
              ],
            ),
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
            onPressed: () {},
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
              Text(
                "Locally sourced seafood and burgers served in a relaxed cafe with modern decor, or to take away.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
