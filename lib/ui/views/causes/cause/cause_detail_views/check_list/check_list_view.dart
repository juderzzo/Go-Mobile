import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

class CheckListView extends StatelessWidget {
  final List actions;
  final List descriptors;
  final String creatorId;
  final String currentUID;
  final String name;
  final String causeID;

  CheckListView({
    this.actions,
    this.descriptors,
    this.creatorId,
    this.currentUID,
    this.name,
    this.causeID,
  });

  Widget checkListItems(model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          CauseCheckListItem(
            isChecked: model.checks[0],
            header: actions[0],
            subHeader: descriptors[0],
            model: model,
            index: 0,
          ),
          verticalSpaceMedium,
          CauseCheckListItem(
            isChecked: model.checks[1],
            header: actions[1],
            subHeader: descriptors[1],
            model: model,
            index: 1,
          ),
          verticalSpaceMedium,
          CauseCheckListItem(
              isChecked: model.checks[2],
              header: actions[2],
              subHeader: descriptors[2],
              model: model,
              index: 1),
          verticalSpaceLarge,
          verticalSpaceLarge,
          creatorId == currentUID
              ? CustomButton(
                  text: "Edit Checklist",
                  textSize: 16,
                  textColor: appFontColor(),
                  height: 40,
                  width: 300,
                  backgroundColor: appButtonColor(),
                  elevation: 2,
                  isBusy: false,
                  onPressed: () {
                    print(causeID);
                    model.navigateToEdit(actions, descriptors, creatorId,
                        currentUID, name, causeID);
                  },
                )
              : SizedBox(

                  ///child: Text(model.userID()),
                  ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListViewModel>.reactive(
      viewModelBuilder: () => CheckListViewModel(),
      builder: (context, model, child) => Container(
        child: checkListItems(model),
      ),
    );
  }
}
