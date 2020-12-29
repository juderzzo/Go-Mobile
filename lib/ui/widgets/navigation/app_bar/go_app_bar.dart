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
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton ? BackButton() : Container(),
      bottom: PreferredSize(
        child: Container(
          color: Colors.black12,
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }
}
