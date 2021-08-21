import 'package:go/app/app.locator.dart';
import 'package:go/enums/dialog_type.dart';
import 'package:stacked_services/stacked_services.dart';

import 'action_item_form_dialog/action_item_form_dialog.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();

  final builders = {
    DialogType.actionItemForm: (context, sheetRequest, completer) => ActionItemFormDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
