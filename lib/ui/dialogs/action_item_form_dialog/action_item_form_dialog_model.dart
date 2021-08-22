import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/platform_data_service.dart';
import 'package:go/services/location/google_places_service.dart';
import 'package:stacked/stacked.dart';

class ActionItemFormDialogModel extends BaseViewModel {
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  GooglePlacesService googlePlacesService = locator<GooglePlacesService>();

  TextEditingController locationTextController = TextEditingController();
  bool requiresLocationVerification = false;

  GoCheckListItem checkListItem = GoCheckListItem();
  bool loadedPreviousHeader = false;
  bool loadedPreviousSubHeader = false;
  bool loadedPreviousLocation = false;

  Map<String, dynamic> placeSearchResults = {};

  bool savingItem = false;

  initialize({GoCheckListItem? item}) async {
    setBusy(true);
    if (item != null) {
      checkListItem = item;
      if (item.lat != null && item.lon != null && item.address != null) {
        requiresLocationVerification = true;
      }
      notifyListeners();
    }
    setBusy(false);
  }

  String loadPreviousHeader() {
    String val = checkListItem.header ?? "";
    loadedPreviousHeader = true;
    notifyListeners();
    return val;
  }

  String loadPreviousSubHeader() {
    String val = checkListItem.subHeader ?? "";
    loadedPreviousSubHeader = true;
    notifyListeners();
    return val;
  }

  String loadPreviousLocation() {
    String val = checkListItem.address ?? "";
    loadedPreviousLocation = true;
    notifyListeners();
    return val;
  }

  updateHeader(String val) {
    checkListItem.header = val.trim();
    notifyListeners();
  }

  updateSubHeader(String val) {
    checkListItem.subHeader = val.trim();
    notifyListeners();
  }

  updatePoints(int points) {
    checkListItem.points = points;
    notifyListeners();
  }

  updateLocation(double lat, double lon, String address) {
    checkListItem.lat = lat;
    checkListItem.lon = lon;
    checkListItem.address = address;
    notifyListeners();
  }

  setPlacesSearchResults(Map<String, dynamic> val) {
    placeSearchResults = val;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getPlaceDetails(String place) async {
    PlatformDataService _platformDataService = locator<PlatformDataService>();
    String? googleKey = await _platformDataService.getGoogleApiKey();
    //set location text
    locationTextController.text = place;
    notifyListeners();
    //get place ID for LAT & LON
    String? placeID = placeSearchResults[place];
    Map<String, dynamic> details = await googlePlacesService.getDetailsFromPlaceID(placeID: placeID!);

    //set place details
    details = {
      'lat': details['lat'],
      'lon': details['lon'],
      'address': place,
    };

    return details;
  }

  toggleRequiresLocationVerification() async {
    if (requiresLocationVerification) {
      requiresLocationVerification = false;
    } else {
      requiresLocationVerification = true;
    }
    notifyListeners();
  }

  ///Sign Up Via Email
  saveCheckListItem({required GoCheckListItem item}) async {
    if (!item.isValid()) {
      return;
    }
    savingItem = true;
    notifyListeners();
    // int itemIndex = checkListItems.indexWhere((val) => val.id == item.id);
    // checkListItems[itemIndex] = item;
    // notifyListeners();
    // bool updatedCheckList = await _causeDataService!.updateCheckListItems(causeID: cause!.id, items: checkListItems);
    // if (updatedCheckList) {
    //   if (send) {
    //     sendChecklistNotifications();
    //   }
    //   _customDialogService.showSuccessDialog(title: "Action Saved", description: "This Action Item Has Been Saved");
    // } else {
    //   _customDialogService.showErrorDialog(description: "There was an issue saving your item. Please Try Again.");
    // }
    savingItem = false;
    notifyListeners();
  }
}
