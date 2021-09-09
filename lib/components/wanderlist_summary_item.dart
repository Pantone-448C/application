import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetListSummary extends StatelessWidget {
  final String activity;

  GetListSummary(this.activity);

  @override
  Widget build(BuildContext context) {
    CollectionReference activities = FirebaseFirestore.instance.collection('wanderlists');

    return FutureBuilder<DocumentSnapshot>(
      future: activities.doc(activity).get(),

      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return WanderlistSummaryItem(
            listName: data['name'],
            authorName: data['author'],
            numTotalItems: data['activities'].length,
            numCompletedItems: data['numComplete'],
            imageUrl: data['icon']
          );
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}

class WanderlistSummaryItem extends StatelessWidget {
  final double width;
  final double height;

  final String listName;
  final String authorName;
  final int numTotalItems;
  final int numCompletedItems;
  final String imageUrl;

  static const double CORNER_RADIUS = 15.0;

  WanderlistSummaryItem({
    Key? key,
    this.width = 375.0,
    this.height = 75.0,
    this.listName = "",
    this.authorName = "",
    this.numTotalItems = 0,
    this.numCompletedItems = 0,
    this.imageUrl = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        width: this.width,
        color: Colors.transparent,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: height / 7.5, horizontal: width / 37.5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS))),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 17,
                  child:
                      _ImageComponent(this.width, this.height, this.imageUrl)),
              Spacer(flex: 4),
              Expanded(
                  flex: 79,
                  child: _TextComponent(
                    this.listName,
                    this.authorName,
                    this.numTotalItems,
                    this.numCompletedItems,
                  )),
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
              borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS)),
              image: new DecorationImage(
                fit: BoxFit.fitHeight,
                alignment: FractionalOffset.topCenter,
                image: new NetworkImage(this.imageUrl),
              )),
        ),
      ),
    );
  }
}

class _TextComponent extends StatelessWidget {
  final String listName;
  final String authorName;
  final int numTotalItems;
  final int numCompletedItems;
  String completed;

  _TextComponent(this.listName, this.authorName, this.numTotalItems,
      this.numCompletedItems)
      : completed = "Completed " +
            numCompletedItems.toString() +
            " of " +
            numTotalItems.toString() +
            " activities";

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Container(
                  child: new Text(listName, style: TextStyle(fontSize: 18)))),
          Expanded(
              flex: 3,
              child: Container(
                  child: new Text("by " + this.authorName,
                      style: TextStyle(fontSize: 12, color: Colors.grey)))),
          Expanded(
              flex: 3,
              child: Container(
                  child: new Text(this.completed,
                      style: TextStyle(fontSize: 12, color: Colors.grey)))),
          Expanded(flex: 1, child: Container()),
        ]);
  }
}
