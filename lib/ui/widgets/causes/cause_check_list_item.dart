import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';

class CauseCheckListItem extends StatelessWidget {
  final bool isChecked;
  final String header;
  final String subHeader;

  CauseCheckListItem({@required this.isChecked, @required this.header, @required this.subHeader});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0.3,
            blurRadius: 1.5,
            offset: Offset(0.0, 1.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: CustomColors.goGreen,
            value: isChecked,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subHeader,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
