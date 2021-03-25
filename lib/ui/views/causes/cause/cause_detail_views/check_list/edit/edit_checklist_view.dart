import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/list_builders/list_check_list_items.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';

class EditCheckListView extends StatelessWidget {
  Widget listCheckListItems(EditCheckListViewModel model) {
    return Expanded(
      child: model.checkListItems.isEmpty && !model.isBusy
          ? Center(
              child: ZeroStateView(
                imageAssetName: 'coding',
                header: "You Have Not Created Any Action Items for This Cause",
                subHeader: "Create an Action for Followers to Get Involved",
                mainActionButtonTitle: null,
                mainAction: null,
                secondaryActionButtonTitle: null,
                secondaryAction: null,
              ),
            )
          : ListCheckListItemsForEditing(
              refreshData: () {},
              items: model.checkListItems,
              pageStorageKey: null,
              scrollController: null,
              onChangedHeader: (val) => model.updateItemHeader(id: val['id'], header: val['header']),
              onChangedSubHeader: (val) => model.updateItemSubHeader(id: val['id'], subHeader: val['subHeader']),
              onSetLocation: (val) => model.updateItemLocationDetails(id: val['id'], lat: val['lat'], lon: val['lon'], address: val['address']),
              onDelete: (val) => model.deleteCheckListItem(id: val),
              onRemoveLocation: (val) => model.deleteItemLocationDetails(id: val),
              onSetPoints: (val) => model.updateItemPoints(id: val['id'], points: val['points']),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditCheckListViewModel>.reactive(
      onModelReady: (model) => model.initialize(context),
      viewModelBuilder: () => EditCheckListViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicActionAppBar(
          title: "Edit Actions",
          showBackButton: true,
          actionWidget: model.isBusy
              ? Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CustomCircleProgressIndicator(
                    size: 20,
                    color: appInActiveColorAlt(),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 20, right: 16),
                  child: GestureDetector(
                    onTap: () => model.submitCheckList(),
                    child: CustomText(
                      text: "Update",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: appFontColor(),
                    ),
                  ),
                ),
        ),
        body: Container(
          color: appBackgroundColor(),
          child: Column(
            children: [
              listCheckListItems(model),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => model.addCheckListItem(),
        ),
      ),
    );
  }
}
