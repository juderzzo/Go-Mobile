import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/location/google_places_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckListItemFormViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  LocationService? _locationService = locator<LocationService>();
  GooglePlacesService? googlePlacesService = locator<GooglePlacesService>();

  TextEditingController locationTextController = TextEditingController();
  TextEditingController headerController = TextEditingController();
  TextEditingController subHeaderController = TextEditingController();
  bool requiresLocationVerification = false;

  Map<String, dynamic> placeSearchResults = {};
  int? points = 0;

  initialize(GoCheckListItem item) async {
    setBusy(true);
    if (item.lat != null && item.lon != null && item.address != null) {
      locationTextController.text = item.address!;
      requiresLocationVerification = true;
      notifyListeners();
    }

    setBusy(false);
    points = item.points;
  }

  setPlacesSearchResults(Map<String, dynamic> val) {
    placeSearchResults = val;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getPlaceDetails(String place) async {
    Map<String, dynamic> details;
    //set location text
    locationTextController.text = place;
    notifyListeners();

    //get place ID for LAT & LON
    String? placeID = placeSearchResults[place];
    Map<String, dynamic> coordinates = await googlePlacesService!.getLatLonFromPlaceID(placeID: placeID);

    //set place details
    details = {
      'lat': coordinates['lat'],
      'lon': coordinates['lon'],
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

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
