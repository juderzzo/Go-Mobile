import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(borderRadius: BorderRadius.circular(5), color: CustomColors.iosOffWhite);

BoxDecoration disabledFieldDecortaion = BoxDecoration(borderRadius: BorderRadius.circular(5), color: CustomColors.iosOffWhite);

// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
const TextStyle buttonTitleTextStyle = const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);
