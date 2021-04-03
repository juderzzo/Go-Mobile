import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/ui/widgets/busy_button.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item/check_list_item_view.dart';
import 'package:go/ui/widgets/common/text_field/text_field_header.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';

class CheckListView extends StatefulWidget {
  final List<GoCheckListItem> checkListItems;
  final bool isCauseAdmin;
  final String causeID;
  final String currentUID;
  final Function(GoCheckListItem) checkOffItem;
  final VoidCallback refreshData;

  CheckListView({
    @required this.checkListItems,
    @required this.isCauseAdmin,
    @required this.causeID,
    @required this.currentUID,
    @required this.checkOffItem,
    @required this.refreshData,
  });

  @override
  _CheckListViewState createState() => _CheckListViewState(
      checkListItems: checkListItems,
      isCauseAdmin: isCauseAdmin,
      causeID: causeID,
      currentUID: currentUID,
      checkOffItem: checkOffItem,
      refreshData: refreshData);
}

class _CheckListViewState extends State<CheckListView>
    with SingleTickerProviderStateMixin {
  final List<GoCheckListItem> checkListItems;
  final bool isCauseAdmin;
  final String causeID;
  final String currentUID;
  final Function(GoCheckListItem) checkOffItem;
  final VoidCallback refreshData;
  TabController _tabController;
  Widget announcementList;
  Widget eventList;

  //TabController controller = TabController(length: 3, vsync: this);

  _CheckListViewState({
    @required this.checkListItems,
    @required this.isCauseAdmin,
    @required this.causeID,
    @required this.currentUID,
    @required this.checkOffItem,
    @required this.refreshData,
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  Widget monetization(model) {
    return Column(
      // ans.add(Text("Monitize"));
      // ans.add(FlatButton(
      //     onPressed: () {
      //       model.adInstance.show();
      //     },
      //     child: Text("Ad")));
      children: model.monetizer
          ? [
              textFieldHeader(
                "Monetization (Point per View)",
                "This cause has been monitized. Each time you choose to watch an ad, a large portion of the precedings are donated to supporting that cause directly. Click on the button below to raise money. You may only watch an ad once every 2 minutes",
              ),
              verticalSpaceSmall,
              BusyButton(
                  busy: model.bus || !model.canWatchVideo,
                  title: "Watch Ad",
                  onPressed: () async {
                    model.playAd(causeID);
                  })
            ]
          : [],
    );
  }

  Widget listCheckListItems(CheckListViewModel model) {

    List announcements = [];
    checkListItems.forEach((element) {
      if (element.lat == null) {
        announcements.add(element);
      }
    });

    return RefreshIndicator(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          if (announcements[index].lat == null) {
            return CheckListItemView(
              item: announcements[index],
              isChecked:
                  announcements[index].checkedOffBy.contains(currentUID),
              checkOffItem: (item) => checkOffItem(item),
            );
          }
        },
      ),
      onRefresh: refreshData,
    );
  }

  Widget listEvents(CheckListViewModel model) {
    List events = [];
    checkListItems.forEach((element) {
      if (element.lat != null) {
        events.add(element);
      }
    });

    return RefreshIndicator(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          //print(events[index].header);
          //print(events[index].lat);
          return CheckListItemView(
            item: events[index],
            isChecked: events[index].checkedOffBy.contains(currentUID),
            checkOffItem: (item) => checkOffItem(item),
          );
        },
      ),
      onRefresh: refreshData,
    );
  }

  Widget tabBar(CheckListViewModel model) {
    return GoChecklistTabBar(
      tabController: _tabController,
    );
  }

  //only initizlize once

  @override
  Widget build(BuildContext context) {
    print(checkListItems.length);
    return ViewModelBuilder<CheckListViewModel>.reactive(
        viewModelBuilder: () => CheckListViewModel(),
        onModelReady: (model) {
          model.initialize(causeID);
          eventList = listEvents(model);
          announcementList = listCheckListItems(model);
        },
        builder: (context, model, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: appBackgroundColor(),
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: _tabController.index == 0
                      ? [
                          isCauseAdmin
                              ? CustomButton(
                                  text: checkListItems.length > 0
                                      ? "Update Action List"
                                      : "Create Action List",
                                  textSize: 16,
                                  textColor: appFontColor(),
                                  height: 40,
                                  width: 320,
                                  backgroundColor: appButtonColor(),
                                  elevation: 2,
                                  isBusy: false,
                                  onPressed: () {
                                    model.navigateToEdit(causeID);
                                  },
                                )
                              : Container(),

                          verticalSpaceSmall,
                          eventList
                          //monetization(model),
                        ]
                      : _tabController.index == 1
                          ? [
                              isCauseAdmin
                                  ? CustomButton(
                                      text: checkListItems.length > 0
                                          ? "Update Action List"
                                          : "Create Action List",
                                      textSize: 16,
                                      textColor: appFontColor(),
                                      height: 40,
                                      width: 320,
                                      backgroundColor: appButtonColor(),
                                      elevation: 2,
                                      isBusy: false,
                                      onPressed: () {
                                        model.navigateToEdit(causeID);
                                      },
                                    )
                                  : Container(),
                              verticalSpaceSmall,
                              announcementList
                            ]
                          : [
                              monetization(model),
                            ],
                ),
                Spacer(),
                tabBar(model),
              ],
            ),
          );
        });
  }
}
