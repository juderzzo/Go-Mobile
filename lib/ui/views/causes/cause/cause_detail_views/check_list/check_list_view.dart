import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:stacked/stacked.dart';

class CheckListView extends StatelessWidget {
  final List actions;

  CheckListView({this.actions});

  Widget checkListItems() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: [
          CauseCheckListItem(isChecked: true, header: actions[0], subHeader: "example of action"),
          verticalSpaceMedium,
          CauseCheckListItem(isChecked: true, header: actions[1], subHeader: "example of action"),
          verticalSpaceMedium,
          CauseCheckListItem(isChecked: false, header: actions[2], subHeader: "example of action"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListViewModel>.reactive(
      viewModelBuilder: () => CheckListViewModel(),
      builder: (context, model, child) => Container(
        child: checkListItems(),
      ),
    );
  }
}
