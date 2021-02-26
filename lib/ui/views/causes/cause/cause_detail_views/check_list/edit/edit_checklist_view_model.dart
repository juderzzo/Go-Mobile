import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditChecklistViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  String causeID;
  List<GoCheckListItem> checkListItems = [];

  initialize(BuildContext context) async {
    setBusy(true);
    Map<String, dynamic> args = RouteData.of(context).arguments;
    causeID = args['causeID'];
    checkListItems = await _causeDataService.getCheckListItems(causeID);

    notifyListeners();
    setBusy(false);
  }

  addCheckListItem() {
    GoCheckListItem item = GoCheckListItem(id: getRandomString(30), causeID: causeID, checkedOffBy: []);
    checkListItems.add(item);
    notifyListeners();
  }

  deleteCheckListItem({@required String id}) {
    checkListItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  bool checkListIsValid() {
    bool isValid = true;
    int numberOfIncompleteItems = 0;
    numberOfIncompleteItems =
        checkListItems.where((item) => item.header == null || item.header.isEmpty || item.subHeader == null || item.subHeader.isEmpty).length;
    if (numberOfIncompleteItems > 0) {
      isValid = false;
    }
    return isValid;
  }

  submitCheckList() async {
    if (checkListIsValid()) {
      bool updatedCheckList = false;
      updatedCheckList = await _causeDataService.updateCheckListItems(causeID: causeID, items: checkListItems);
      if (updatedCheckList) {
        _navigationService.popRepeated(2);
      }
    } else {
      _snackbarService.showSnackbar(
        title: 'Check List Incomplete',
        message: "One or More of Your Check List Items is Incomplete",
        duration: Duration(seconds: 5),
      );
    }
  }
}
