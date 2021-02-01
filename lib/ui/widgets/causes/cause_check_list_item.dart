import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/utils/random_string_generator.dart';

class CauseCheckListItem extends StatelessWidget {
  bool isChecked;

  final String header;
  final String subHeader;
  final id;

  CauseCheckListItem({
    @required this.id,
    @required this.isChecked,
    @required this.header,
    @required this.subHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: appTextFieldContainerColor(),
        border: Border.all(width: 1.0, color: appBorderColorAlt()),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: appShadowColor(),
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
            //tristate: true,
            value: isChecked,
            onChanged: (value) {
              //value = true;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontSize: 16,
                  color: appFontColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 292,
                child: Text(
                  subHeader,
                  
                  style: TextStyle(
                    fontSize: 14,
                    color: appFontColor(),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
