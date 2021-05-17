import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png", height: 50,),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white30,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      )
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white54,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}