import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/common/custom_text.dart';

class CustomAppBar {
  Widget basicAppBar({@required String title, @required bool showBackButton}) {
    return AppBar(
      elevation: 0,
      backgroundColor: appBackgroundColor(),
      title: CustomOverflowText(
        text: title,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        textOverflow: TextOverflow.ellipsis,
      ),
      brightness: appBrightness(),
      leading: showBackButton ? BackButton(color: appIconColor()) : Container(),
      bottom: PreferredSize(
        child: Container(
          color: appBorderColor(),
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }

  Widget basicActionAppBar({@required String title, @required bool showBackButton, @required actionWidget}) {
    return AppBar(
      elevation: 0,
      backgroundColor: appBackgroundColor(),
      title: Text(
        title,
        style: TextStyle(
          color: appFontColor(),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      brightness: appBrightness(),
      leading: showBackButton ? BackButton(color: appIconColor()) : Container(),
      actions: [
        actionWidget,
      ],
      bottom: PreferredSize(
        child: Container(
          color: appBorderColor(),
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }
}
