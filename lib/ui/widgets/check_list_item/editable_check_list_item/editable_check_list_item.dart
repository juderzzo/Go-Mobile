import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';

class EditableCheckListItem extends StatelessWidget {
  final GoCheckListItem item;
  final VoidCallback editItem;
  final VoidCallback deleteItem;

  EditableCheckListItem({
    required this.item,
    required this.editItem,
    required this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: item.header,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          verticalSpaceSmall,
          CustomText(
            text: item.subHeader,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: appFontColor(),
          ),
          verticalSpaceSmall,
          item.address != null && item.address!.isNotEmpty
              ? CustomText(
                  text: item.address,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                )
              : Container(),
          verticalSpaceSmall,
          Row(
            children: [
              CustomTextButton(
                onTap: editItem,
                text: 'Edit Item',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appTextButtonColor(),
              ),
              horizontalSpaceMedium,
              CustomTextButton(
                onTap: deleteItem,
                text: 'Delete Item',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: appDestructiveColor(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
