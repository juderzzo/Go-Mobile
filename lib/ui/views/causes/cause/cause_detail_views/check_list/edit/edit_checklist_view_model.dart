import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditCheckListViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  GoCause cause;
  List<GoCheckListItem> checkListItems = [];

  initialize(BuildContext context) async {
    setBusy(true);
    Map<String, dynamic> args = RouteData.of(context).arguments;
    String causeID = args['id'];
    cause = await _causeDataService.getCauseByID(causeID);
    print(cause);
    checkListItems = await _causeDataService.getCheckListItems(causeID);

    notifyListeners();
    setBusy(false);
  }

  addCheckListItem() {
    GoCheckListItem item = GoCheckListItem(
        id: getRandomString(30),
        causeID: cause.id,
        checkedOffBy: [],
        dateTimePublished: DateTime.now().millisecondsSinceEpoch,
        points: 0);
    checkListItems.add(item);
    notifyListeners();
  }

  updateItemHeader({String id, String header}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].header = header;
    notifyListeners();
  }

  updateItemSubHeader({String id, String subHeader}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].subHeader = subHeader;
    notifyListeners();
  }

  updateItemPoints({String id, int points}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].points = points;
    notifyListeners();
  }

  updateItemLocationDetails(
      {String id, double lat, double lon, String address}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].lat = lat;
    checkListItems[itemIndex].lon = lon;
    checkListItems[itemIndex].address = address;
    notifyListeners();
  }

  deleteItemLocationDetails({String id}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].lat = null;
    checkListItems[itemIndex].lon = null;
    checkListItems[itemIndex].address = null;
    notifyListeners();
  }

  editItemPoints({String id, int points}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].points = points;
    notifyListeners();
  }

  deleteCheckListItem({@required String id}) {
    checkListItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  bool checkListIsValid() {
    bool isValid = true;
    int numberOfIncompleteItems = 0;
    numberOfIncompleteItems = checkListItems
        .where((item) =>
            item.header == null ||
            item.header.isEmpty ||
            item.subHeader == null ||
            item.subHeader.isEmpty)
        .length;
    if (numberOfIncompleteItems > 0) {
      isValid = false;
    }
    return isValid;
  }

  submitCheckList() async {
    if (checkListIsValid()) {
      bool updatedCheckList = false;
      updatedCheckList = await _causeDataService.updateCheckListItems(
          causeID: cause.id, items: checkListItems);
      if (updatedCheckList) {
        _navigationService.popRepeated(2);
        _navigationService.navigateTo(Routes.CauseViewRoute,
            arguments: {"id": cause.id, "tab": 1});
      }
    } else {
      _snackbarService.showSnackbar(
        title: 'Actions Incomplete',
        message: "One or More of Your Actions Items is Incomplete",
        duration: Duration(seconds: 5),
      );
    }
  }
}
