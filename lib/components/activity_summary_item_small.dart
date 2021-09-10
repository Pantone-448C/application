import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../apptheme.dart';

class ActivitySummaryItem extends StatelessWidget {
  final double height;
  final double width;
  final String activityName;
  final String activityDescription;
  final String documentName;
  final String imageUrl;
  final bool complete;

  static const double CORNER_RADIUS = 15.0;

  ActivitySummaryItem({
    Key? key,
    this.activityName = "",
    this.activityDescription = "",
    this.documentName = "",
    this.imageUrl = "",
    this.width = 375.0,
    this.height = 75.0,
    this.complete = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        width: this.width,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS))),
            child: Row(children: <Widget>[
              Expanded (
                  flex:0,
                  child: _ImageComponent(this.width, this.height, this.imageUrl)),
              Expanded (
                  child: Container (
                    padding: const EdgeInsets.all(8),
                    child: _TextComponent(activityName, activityDescription)
              ))
            ])));
  }
}

class _ImageComponent extends StatelessWidget {
  final double parentWidth;
  final double parentHeight;
  final String imageUrl;

  static const double CORNER_RADIUS = 18.0;

  _ImageComponent(this.parentWidth, this.parentHeight, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new AspectRatio(
        aspectRatio: 1 / 1,
        child: new Container(
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(CORNER_RADIUS),
              bottomLeft: Radius.circular(CORNER_RADIUS)),
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
    return Expanded (child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: new Text(activityName,
                      style: theme.materialTheme.textTheme.headline4)),
                Flexible (
                  child: Container(
                      child: Text(activityDescription,
                          style: theme.materialTheme.textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                          softWrap:true,
                          maxLines:2,
                          ))),
        ]));
  }
}


