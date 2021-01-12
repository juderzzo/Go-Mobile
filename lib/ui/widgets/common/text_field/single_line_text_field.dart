import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';

class SingleLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int textLimit;
  final bool isPassword;
  SingleLineTextField({
    @required this.controller,
    @required this.hintText,
    @required this.textLimit,
    @required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: appFontColor(),
        obscureText: isPassword,
        inputFormatters: textLimit == null
            ? []
            : [
                LengthLimitingTextInputFormatter(textLimit),
              ],
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}