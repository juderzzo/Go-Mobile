import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';

final String fontFamily = "Open Sans";

ThemeData regularTheme = ThemeData(
  backgroundColor: Colors.white,
  accentColor: CustomColors.goGreen,
  brightness: Brightness.light,
  fontFamily: fontFamily,
);

ThemeData darkTheme = ThemeData(
  backgroundColor: CustomColors.blackPearl,
  accentColor: CustomColors.goGreen,
  brightness: Brightness.dark,
  fontFamily: fontFamily,
);

List<ThemeData> appThemes = [
  regularTheme,
  darkTheme,
];
