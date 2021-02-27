import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_check_list_item.dart';

class CauseCheckListItem extends StatelessWidget {
  final bool isChecked;
  final GoCheckListItem item;
  final Function(GoCheckListItem) checkOffItem;

  CauseCheckListItem({
    @required this.isChecked,
    @required this.item,
    @required this.checkOffItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: checkOffItem(item),
      child: Container(
        //width: MediaQuery.of(context).size.width * 1/3,
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
            isChecked
                ? Checkbox(
                    activeColor: CustomColors.goGreen,
                    //tristate: true,
                    value: isChecked,
                    onChanged: (value) {
                      //value = true;
                    },
                  )
                : SizedBox(width: 43, child: Icon(Icons.check_box_outline_blank)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.header,
                  style: TextStyle(
                    fontSize: 16,
                    color: appFontColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 11 / 16,
                  child: Text(
                    item.subHeader,
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
      ),
    );
  }
}
