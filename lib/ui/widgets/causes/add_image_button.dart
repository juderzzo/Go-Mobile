import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';

class AddImageButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? iconSize;
  final double? height;
  final double? width;

  AddImageButton({this.onTap, this.iconSize, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: appBorderColorAlt(),
        height: height,
        width: width,
        child: Center(
          child: Icon(
            FontAwesomeIcons.camera,
            size: iconSize,
            color: appIconColorAlt(),
          ),
        ),
      ),
    );
  }
}
