import 'package:flutter/material.dart';

class GoNavBar extends StatelessWidget {
  final List<Widget> navBarItems;

  GoNavBar({this.navBarItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0.5,
            blurRadius: 1.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navBarItems,
      ),
    );
  }
}
