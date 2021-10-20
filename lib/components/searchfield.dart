import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchField extends StatelessWidget {
  final String hint;

  SearchField(this.hint);

  static InputDecoration defaultDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    ),
    filled: true,
    hintStyle: TextStyle(color: Colors.grey[800], height: 1),
    fillColor: Colors.grey[300],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextField(
        decoration: defaultDecoration.copyWith(hintText: hint),
//        style: TextStyle(height: 1),
      ),
    );
  }
}
