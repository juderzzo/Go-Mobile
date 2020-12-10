import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';

class GoNavBarItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final IconData iconData;
  final String label;

  GoNavBarItem({this.onTap, this.isActive, this.iconData, this.label});
  @override
  Widget build(BuildContext context) {
    Color activeColor = CustomColors.goGreen;
    Color inactiveColor = Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 48,
        child: Column(
          children: [
            Icon(
              iconData,
              color: isActive ? activeColor : inactiveColor,
              size: 20,
            ),
            SizedBox(height: 2),
            label == null
                ? Container()
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
