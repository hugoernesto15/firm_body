import 'package:flutter/material.dart';

const List<Color> listColor = [
  Color(0xff151312),
  Color(0xff1E1C1A),
  Color(0xff211F1F),
  Color(0xff252224),
  Color(0xff312F30),
  Color(0xff3F3F3F),
  Color(0xff4D4C4F),
  Color(0xff5B5A5D),
];

const kInputDecoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.tealAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
