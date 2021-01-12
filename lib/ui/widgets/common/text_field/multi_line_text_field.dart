import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';

class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  MultiLineTextField({
    @required this.controller,
    @required this.hintText,
    @required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: appFontColorAlt(),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}