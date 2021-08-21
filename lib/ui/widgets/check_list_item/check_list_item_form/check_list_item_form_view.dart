import 'package:flutter/material.dart';
import 'package:go/models/go_check_list_item.dart';
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
        return Container();
      },
    );
  }
}
