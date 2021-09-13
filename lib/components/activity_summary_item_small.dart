import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../apptheme.dart';

class ActivitySummaryItemSmall extends StatelessWidget {
  final double height;
  final double width;
  final String activityName;
  final String activityDescription;
  final String documentName;
  final String imageUrl;
  final bool complete;


  ActivitySummaryItemSmall(
      {Key? key,
      this.activityName = "",
      this.activityDescription = "",
      this.documentName = "",
      this.imageUrl = "",
      this.width = 375.0,
      this.height = 75.0,
      this.complete = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        width: this.width,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(WanTheme.CARD_CORNER_RADIUS))),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 0,
                  child:
                      _ImageComponent(this.width, this.height, this.imageUrl)),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: _TextComponent(activityName, activityDescription))),
              Container (
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
            ])));
  }
}

class _ImageComponent extends StatelessWidget {
  final double parentWidth;
  final double parentHeight;
  final String imageUrl;


  _ImageComponent(this.parentWidth, this.parentHeight, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new AspectRatio(
        aspectRatio: 1 / 1,
        child: new Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
                bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS)),
            image: new DecorationImage(
              fit: BoxFit.fitHeight,
              alignment: FractionalOffset.topCenter,
              image: new NetworkImage(this.imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextComponent extends StatelessWidget {
  final String activityName;
  final String activityDescription;

  _TextComponent(this.activityName, this.activityDescription);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(bottom: 3),
              child: new Text(activityName,
                  style: WanTheme.materialTheme.textTheme.headline4)),
          Container(
              child: Text(
            activityDescription,
            style: WanTheme.materialTheme.textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          )),
        ]);
  }
}
