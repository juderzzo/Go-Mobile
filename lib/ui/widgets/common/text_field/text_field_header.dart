import 'package:flutter/cupertino.dart';
import 'package:go/constants/app_colors.dart';

Widget textFieldHeader(String header, String subHeader) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ),
          SizedBox(height: 4),
          Text(
            subHeader,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: appFontColorAlt(),
            ),
          ),
        ],
      ),
    );
  }