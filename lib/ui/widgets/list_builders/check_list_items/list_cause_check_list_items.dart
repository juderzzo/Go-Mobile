import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item/check_list_item_view.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:stacked/stacked.dart';

import 'list_cause_check_list_items_model.dart';

class ListCauseCheckListItems extends StatelessWidget {
  final String causeID;
  final bool isAdmin;
  ListCauseCheckListItems({required this.causeID, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListCauseCheckListItemsModel>.reactive(
      onModelReady: (model) => model.initialize(causeID),
      viewModelBuilder: () => ListCauseCheckListItemsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.checkListItems.isEmpty
              ? isAdmin
                  ? ZeroStateView(
                      imageAssetName: "coding",
                      header: "No Items Found",
                      subHeader: "Start a Movement and Create a Cause",
                      mainActionButtonTitle: "Create Item",
                      mainAction: () => model.appBaseViewModel.setBusy(true),
                      secondaryActionButtonTitle: null,
                      secondaryAction: null,
                    )
                  : ZeroStateView(
                      imageAssetName: "coding",
                      header: "No Items Found",
                      subHeader:
                          "This cause does not have any actions or events yet.",
                      //mainActionButtonTitle: null,
                      //mainAction: () => null,
                      secondaryActionButtonTitle: null,
                      secondaryAction: null,
                    )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor(),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      model.initialize(causeID);
                    },
                    backgroundColor: appBackgroundColor(),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: model.scrollController,
                      // key: UniqueKey(),
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      itemCount: model.checkListItems.length,
                      itemBuilder: (context, index) {
                        return CheckListItemView(
                          item: model.checkListItems[index],
                          isChecked: model.checkListItems[index].checkedOffBy!
                              .contains(model.user.id),
                          checkOffItem: (item) => model.checkOffItem(item),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
