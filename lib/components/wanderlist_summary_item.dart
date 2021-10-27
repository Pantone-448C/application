import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../apptheme.dart';

class GetListSummary extends StatelessWidget {
  final String activity;

  GetListSummary(this.activity);

  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('wanderlists');

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
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return WanderlistSummaryItem(
              listName: data['name'],
              authorName: data['author'],
              numTotalItems: data['activities'].length,
              numCompletedItems: data['numComplete'],
              imageUrl: data['icon']);
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
  final bool isPinned;

  /// Null to not show the pin button
  final void Function()? onPinTap;

  WanderlistSummaryItem({
    Key? key,
    this.width = 375.0,
    this.height = 75.0,
    this.listName = "",
    this.authorName = "",
    this.numTotalItems = 0,
    this.numCompletedItems = 0,
    this.imageUrl = "",
    this.isPinned = false,
    this.onPinTap,
  });

  @override
  Widget build(BuildContext context) {
    int imageFlex, textFlex, pinFlex;
    if (onPinTap != null) {
      imageFlex = 17;
      textFlex = 59;
      pinFlex = 20;
    } else {
      imageFlex = 17;
      textFlex = 79;
      pinFlex = 0;
    }
    var icon;
    if (isPinned == true) {
      icon = Icon(Icons.push_pin_rounded);
    } else if (isPinned == false) {
      icon = Icon(Icons.push_pin_outlined);
    }
    return Ink(
      height: this.height,
      width: this.width,
      padding: EdgeInsets.symmetric(
        vertical: height / 7.5,
        horizontal: width / 37.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(WanTheme.CARD_CORNER_RADIUS),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: imageFlex,
            child: _ImageComponent(this.width, this.height, this.imageUrl,
              this.listName),
          ),
          Spacer(flex: 4),
          Expanded(
            flex: textFlex,
            child: _TextComponent(
              this.listName,
              this.authorName,
              this.numTotalItems,
              this.numCompletedItems,
            ),
          ),
          if (onPinTap != null)
            Expanded(
              flex: pinFlex,
              child: IconButton(
                icon: icon,
                onPressed: () {
                  onPinTap?.call();
                },
              ),
            )
        ],
      ),
    );
  }
}

class _ImageComponent extends StatelessWidget {
  final double parentWidth;
  final double parentHeight;
  final String imageUrl;
  final String text;

  _ImageComponent(this.parentWidth, this.parentHeight, this.imageUrl, this.text);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != "")
      return new Center(
        child: new AspectRatio(
          aspectRatio: 1 / 1,
          child: new Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(WanTheme.THUMB_CORNER_RADIUS),
              ),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                alignment: FractionalOffset.topCenter,
                image: new NetworkImage(this.imageUrl),
              ),
            ),
          ),
        ),
      );
    else {
      return new Center(
        child: new AspectRatio(
          aspectRatio: 1 / 1,
          child: new Container(
            decoration: new BoxDecoration(
              color: WanTheme.colors.pink,
              borderRadius: BorderRadius.all(
                Radius.circular(WanTheme.THUMB_CORNER_RADIUS),
              ),
            ),
            child: Center (child: Container (
                color: WanTheme.colors.pink,
                child: Text(text[0].toUpperCase(), style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: WanTheme.colors.white,
                )))),
          ),
        ),
      );



      return new Center(
        child: new AspectRatio(
          aspectRatio: 1 / 1,
          child: new Container(
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(WanTheme.THUMB_CORNER_RADIUS),
                ),
            ),
          ),
        ),
      );


      return Center (child: Container (
        color: WanTheme.colors.pink,
          child: Text(text[0].toUpperCase(), style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: WanTheme.colors.white,
      ))));
    }
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
      : completed = "Contains " +
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
            child: Text(listName, style: WanTheme.text.cardTitle),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(
              "by " + this.authorName,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(
              this.completed,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}
