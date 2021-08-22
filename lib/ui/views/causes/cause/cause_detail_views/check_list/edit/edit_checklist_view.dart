import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view_model.dart';
import 'package:go/ui/widgets/check_list_item/editable_check_list_item/editable_check_list_item.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class EditCheckListView extends StatelessWidget {
  final String? id;
  EditCheckListView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditCheckListViewModel>.reactive(
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(id),
      viewModelBuilder: () => EditCheckListViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: CustomAppBar().basicAppBar(
            title: "Edit Actions",
            showBackButton: true,
          ),
          body: Container(
            color: appBackgroundColor(),
            child: RefreshIndicator(
              onRefresh: () => model.refreshList(),
              child: Column(
                children: [
                  model.updatingCheckList
                      ? CustomLinearProgressIndicator(
                          color: appActiveColor(),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  Expanded(
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
                        : Container(
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              key: model.key,
                              addAutomaticKeepAlives: true,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                              ),
                              itemCount: model.checkListItems.length,
                              itemBuilder: (context, index) {
                                //print(items[index].id);
                                //print(items[index].header);

                                return EditableCheckListItem(
                                  item: model.checkListItems[index],
                                  editItem: () => model.editCheckListItem(item: model.checkListItems[index]),
                                  deleteItem: () => model.deleteCheckListItem(item: model.checkListItems[index]),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => model.addCheckListItem(),
          ),
        ),
      ),
    );
  }
}
