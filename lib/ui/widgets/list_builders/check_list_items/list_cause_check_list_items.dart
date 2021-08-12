import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item/check_list_item_view.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';

import 'list_cause_check_list_items_model.dart';

class ListCauseCheckListItems extends StatelessWidget {
  final String causeID;

  TabController _tabController = useTabController(initialLength: 2);
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
                  imageAssetName: "binos",
                  header: "No Actions Found",
                  subHeader: " ",
                  mainActionButtonTitle: "Create Item",
                  mainAction: () => model.customNavigationService
                      .navigateToCreateActionItems(causeID),
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
                )
              : Container(
                  color: appBackgroundColor(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: screenHeight(context) * 3 / 5,
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
                              //print(model.checkListItems[index].address);
                              //show announcements if tab is 1 show events if tab is 0
                              Iterable<GoCheckListItem> announcements = model
                                  .checkListItems
                                  .where((element) => element.lat == null);

                              if (_tabController.index == 0) {
                                if (announcements.length ==
                                    model.checkListItems.length) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      ZeroStateView(
                                        imageAssetName: "binos",
                                        header: "There are no events",
                                        subHeader:
                                            "Click announcements to see what's new",
                                      ),
                                    ],
                                  );
                                }
                                return model.checkListItems[index].lat != null
                                    ? CheckListItemView(
                                        item: model.checkListItems[index],
                                        isChecked: model
                                            .checkListItems[index].checkedOffBy!
                                            .contains(model.user.id),
                                        checkOffItem: (item) =>
                                            model.checkOffItem(item))
                                    : Container();
                              } else if (_tabController.index == 1) {
                                if (announcements.isEmpty) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      ZeroStateView(
                                        imageAssetName: "binos",
                                        header: "There are no events",
                                        subHeader:
                                            "Click announcements to see what's new",
                                      ),
                                    ],
                                  );
                                }
                                return model.checkListItems[index].lat == null
                                    ? CheckListItemView(
                                        item: model.checkListItems[index],
                                        isChecked: model
                                            .checkListItems[index].checkedOffBy!
                                            .contains(model.user.id),
                                        checkOffItem: (item) =>
                                            model.checkOffItem(item))
                                    : Container();
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                      (model.cause!.creatorID == model.user.id)
                          ? TextButton(
                              //onPressed: ,
                              onPressed: () {
                                model.customNavigationService
                                    .navigateToCreateActionItems(causeID);
                              },
                              child: Text('Edit Checklist'),
                            )
                          : Container(),
                      Spacer(),
                      GoChecklistTabBar(
                        tabController: _tabController,
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ),
    );
  }
}
