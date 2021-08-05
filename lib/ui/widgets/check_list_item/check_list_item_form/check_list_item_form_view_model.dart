import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/platform_data_service.dart';
import 'package:go/services/location/google_places_service.dart';
import 'package:stacked/stacked.dart';

class CheckListItemFormViewModel extends BaseViewModel {
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  GooglePlacesService? googlePlacesService = locator<GooglePlacesService>();

  TextEditingController locationTextController = TextEditingController();
  bool requiresLocationVerification = false;

  GoCheckListItem checkListItem = GoCheckListItem();
  bool loadedPreviousHeader = false;
  bool loadedPreviousSubHeader = false;
  bool loadedPreviousLocation = false;

  Map<String, dynamic> placeSearchResults = {};

  initialize(GoCheckListItem item) async {
    setBusy(true);
    checkListItem = item;
    if (item.lat != null && item.lon != null && item.address != null) {
      requiresLocationVerification = true;
    }
    notifyListeners();
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
    Map<String, dynamic> details =
        await googlePlacesService!.getDetailsFromPlaceID(placeID: placeID!);
   
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

  GoCheckListItem saveItem() {
    if (checkListItem.header == null || checkListItem.header!.isEmpty) {
      _customDialogService.showErrorDialog(
          description: "Action Title Required");
      return GoCheckListItem();
    } else if (checkListItem.subHeader == null ||
        checkListItem.subHeader!.isEmpty) {
      _customDialogService.showErrorDialog(
          description: "Action Description Required");
      return GoCheckListItem();
    }
    return checkListItem;
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
