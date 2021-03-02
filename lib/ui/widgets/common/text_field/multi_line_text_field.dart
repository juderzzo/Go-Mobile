import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';

class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String initialValue;
  final int maxLines;
  final Function(String) onChanged;
  final Function(String) onSubmitted;

  MultiLineTextField({
    @required this.controller,
    @required this.hintText,
    @required this.initialValue,
    @required this.maxLines,
    @required this.onChanged,
    @required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        cursorColor: appCursorColor(),
        maxLines: maxLines,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        enableInteractiveSelection: true,
        onFieldSubmitted: onSubmitted == null ? null : (val) => onSubmitted(val),
        onChanged: onChanged == null ? null : (val) => onChanged(val),
      ),
    );
  }
}
