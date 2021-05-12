import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ListCauseCheckListItemsModel extends BaseViewModel {
  CauseDataService _causeDataService = locator<CauseDataService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();
  LocationService _locationService = locator<LocationService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  DialogService _dialogService = locator<DialogService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-cause-list-items-key";

  ///DATA
  GoUser get user => _reactiveUserService.user;
  late String causeID;
  List<GoCheckListItem> checkListItems = [];

  Future<void> initialize(String id) async {
    checkListItems = await _causeDataService.getCheckListItems(id);
    notifyListeners();
  }

  checkOffItem(GoCheckListItem item) async {
    List checkedOffBy = item.checkedOffBy!.toList(growable: true);
    if (!checkedOffBy.contains(user.id)) {
      DialogResponse? response = await _dialogService.showConfirmationDialog(
        title: "Are You Sure You've Completed this Task?",
        description: "Checking off this task is irreversible",
        cancelTitle: "Cancel",
        confirmationTitle: "Confirm",
        barrierDismissible: true,
      );
      if (response != null && response.confirmed) {
        //validate location if required
        if (item.lat != null && item.lon != null && item.address != null) {
          bool isNearbyLocation = await _locationService.isNearbyLocation(lat: item.lat!, lon: item.lon!);
          if (!isNearbyLocation) {
            _dialogService.showDialog(
              title: "Location Error",
              description: "You are not near the required location to check off this item.",
              buttonTitle: "Ok",
            );
            return;
          }
        }
        //check off item
        checkedOffBy.add(user.id);

        await _causeDataService.checkOffCheckListItem(id: item.id, checkedOffBy: checkedOffBy);
        await _userDataService.updateGoUserPoints(user.id, item.points!);
      }
    }
  }
}
