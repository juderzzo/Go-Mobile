import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  CustomText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.textAlign,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign == null ? TextAlign.left : textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class CustomOverflowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextOverflow textOverflow;
  CustomOverflowText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.textOverflow,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class CustomFittedText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final double height;
  final double width;
  CustomFittedText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.textAlign,
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      //width: width,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text!,
          textAlign: textAlign == null ? TextAlign.left : textAlign,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}
