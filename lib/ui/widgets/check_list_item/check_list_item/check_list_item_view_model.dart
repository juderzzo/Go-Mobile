import 'package:go/app/app.locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';

class CheckListItemViewModel extends BaseViewModel {
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  bool isChecked = false;

  initialize(GoCheckListItem item) {
    if (item.checkedOffBy != null && item.checkedOffBy!.isNotEmpty) {
      if (item.checkedOffBy!.contains(_reactiveUserService.user.id!)) {
        isChecked = true;
        notifyListeners();
      }
    }
  }

  updateIsChecked(bool val) {
    isChecked = val;
    notifyListeners();
  }
}
