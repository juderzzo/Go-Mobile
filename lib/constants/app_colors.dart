import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:stacked_themes/stacked_themes.dart';

ThemeService _themeService = locator<ThemeService>();

bool isDarkMode() {
  return _themeService.isDarkMode;
}

Color appBackgroundColor() {
  return _themeService.isDarkMode ? CustomColors.blackPearl : Colors.white;
}

Color appButtonColor() {
  return _themeService.isDarkMode ? CustomColors.blackPearl : Colors.white;
}

Color appButtonColorAlt() {
  return _themeService.isDarkMode ? CustomColors.nightShimmer : CustomColors.iosOffWhite;
}

Color appIconColor() {
  return _themeService.isDarkMode ? Colors.white : Colors.black;
}

Color appIconColorAlt() {
  return _themeService.isDarkMode ? Colors.white38 : Colors.black45;
}

Color appFontColor() {
  return _themeService.isDarkMode ? CustomColors.iosOffWhite : Colors.black;
}

Color appFontColorAlt() {
  return _themeService.isDarkMode ? Colors.white54 : Colors.black38;
}

Color appPostBorderColor() {
  return _themeService.isDarkMode ? Colors.white12 : CustomColors.iosOffWhite;
}

Color appBorderColor() {
  return _themeService.isDarkMode ? Colors.white24 : Colors.black26;
}

Color appBorderColorAlt() {
  return _themeService.isDarkMode ? Colors.white12 : Colors.black12;
}

Color appActiveColor() {
  return CustomColors.goGreen;
}

Color appInActiveColor() {
  return _themeService.isDarkMode ? Colors.white : Colors.black;
}

Color appInActiveColorAlt() {
  return _themeService.isDarkMode ? Colors.white38 : Colors.black38;
}

Color appDestructiveColor() {
  return Colors.redAccent;
}

Color appShadowColor() {
  return _themeService.isDarkMode ? Colors.white12 : Colors.black12;
}

Color appTextFieldContainerColor() {
  return _themeService.isDarkMode ? Colors.white12 : CustomColors.iosOffWhite;
}

Color appTextButtonColor() {
  return Colors.blue;
}

Color appShimmerBaseColor() {
  return _themeService.isDarkMode ? Colors.grey : CustomColors.iosOffWhite;
}

Color appShimmerHighlightColor() {
  return _themeService.isDarkMode ? CustomColors.nightShimmer : Colors.white;
}

Brightness appBrightness() {
  return _themeService.isDarkMode ? Brightness.dark : Brightness.light;
}
