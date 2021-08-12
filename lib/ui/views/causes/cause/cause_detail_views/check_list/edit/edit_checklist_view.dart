import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/list_builders/list_check_list_items.dart';
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
            child: Column(
              children: [
                model.savingItem
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
                          child: Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                              Text('You have created any actions',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17)),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Click the "+"  to get started')
                            ])))
                      : ListCheckListItemsForEditing(
                          refreshData: () {},
                          items: model.checkListItems,
                          pageStorageKey: UniqueKey(),
                          scrollController: null,
                          onDelete: (val) =>
                              model.deleteCheckListItem(item: val),
                          onSave: (val) => model.saveCheckListItem(item: val),
                        ),
                ),
              ],
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
