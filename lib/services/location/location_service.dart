import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/firestore/platform_data_service.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class LocationService {
  Map<String, double> currentLocation;
  Location currentUserLocation = Location();
  SnackbarService _snackbarService = locator<SnackbarService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();

  Future<LocationData> getCurrentLocation() async {
    LocationData locationData;
    try {
      locationData = await currentUserLocation.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: "Please Enable Location Services from Your App Settings to Find Events",
          onTap: (val) => openAppSettings(),
          duration: Duration(seconds: 5),
        );
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        _snackbarService.showSnackbar(
          title: 'Error',
          message: "Please Enable Location Services from Your App Settings to Find Events",
          onTap: (val) => openAppSettings(),
          duration: Duration(seconds: 5),
        );
      }
      locationData = null;
    }
    return locationData;
  }

  Future<String> getAddressFromLatLon(double lat, double lon) async {
    String foundAddress;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    foundAddress = address.addressLine;
    return foundAddress;
  }

  Future<String> getZipFromLatLon(double lat, double lon) async {
    String zip;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates).catchError((e) {});
    var address = addresses.first;
    zip = address.postalCode;
    return zip;
  }

  Future<String> getCityNameFromLatLon(double lat, double lon) async {
    String cityName;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    cityName = address.locality;
    return cityName;
  }

  Future<String> getProvinceFromLatLon(double lat, double lon) async {
    String province;
    Coordinates coordinates = Coordinates(lat, lon);
    String googleAPIKey = await _platformDataService.getGoogleApiKey().catchError((e) {});
    var addresses = await Geocoder.google(googleAPIKey).findAddressesFromCoordinates(coordinates);
    var address = addresses.first;
    province = address.adminArea;
    return province;
  }
}
