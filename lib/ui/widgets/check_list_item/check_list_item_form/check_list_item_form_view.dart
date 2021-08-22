import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:stacked/stacked.dart';

import 'check_list_item_form_view_model.dart';

class CheckListItemFormView extends StatelessWidget {
  final GoCheckListItem item;
  final Function(GoCheckListItem) onDelete;
  final Function(GoCheckListItem) onSave;

  CheckListItemFormView({
    required this.item,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListItemFormViewModel>.reactive(
      // initialiseSpecialViewModelsOnce: true,
      // onModelReady: (model) => model.initialize(item),
      viewModelBuilder: () => CheckListItemFormViewModel(),
      builder: (context, model, child) {
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
              model.requiresLocationVerification
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
                    onTap: () => onSave(model.saveItem()),
                    text: 'Edit Item',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appTextButtonColor(),
                  ),
                  horizontalSpaceMedium,
                  CustomTextButton(
                    onTap: () => onDelete(item),
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
      },
    );
  }
}
