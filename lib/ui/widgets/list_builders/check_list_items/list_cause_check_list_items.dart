import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item/check_list_item_view.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:stacked/stacked.dart';

import 'list_cause_check_list_items_model.dart';

class ListCauseCheckListItems extends StatelessWidget {
  final String causeID;
  ListCauseCheckListItems({required this.causeID});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListCauseCheckListItemsModel>.reactive(
      onModelReady: (model) => model.initialize(causeID),
      viewModelBuilder: () => ListCauseCheckListItemsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.checkListItems.isEmpty
              ? ZeroStateView(
                  imageAssetName: "coding",
                  header: "No Items Found",
                  subHeader: "Create Action Items for Followers",
                  mainActionButtonTitle: "Create Item",
                  mainAction: () => model.appBaseViewModel.setBusy(true),
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
                )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor(),
                  child: RefreshIndicator(
                    onRefresh: model.refreshData,
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
                          isChecked: model.checkListItems[index].checkedOffBy!.contains(model.user.id),
                          checkOffItem: (item) => model.checkOffItem(item),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
