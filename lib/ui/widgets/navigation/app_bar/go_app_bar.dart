import 'package:flutter/material.dart';

class GoAppBar {
  Widget basicAppBar({@required String title, @required bool showBackButton}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton ? BackButton() : Container(),
    );
  }
}
