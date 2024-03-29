import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:stacked_services/stacked_services.dart';

class LocationService {
  Map<String, double>? currentLocation;
  Location currentUserLocation = Location();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  Future<LocationData?> getCurrentLocation() async {
    LocationData? locationData;
    try {
      locationData = await currentUserLocation.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: "Please Enable Location Services from Your App Settings to Find Causes & Events",
          onTap: (val) => Geolocator.openAppSettings(),
          duration: Duration(seconds: 5),
        );
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: "Please Enable Location Services from Your App Settings to Find Causes & Events",
          onTap: (val) => Geolocator.openAppSettings(),
          duration: Duration(seconds: 5),
        );
      }
      locationData = null;
    }
    return locationData;
  }

  Future<Map<dynamic, dynamic>?> reverseGeocodeLatLon(double lat, double lon) async {
    Map<dynamic, dynamic>? data;
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'reverseGeocodeLatLon',
    );
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'lat': lat,
        'lon': lon,
      },
    ).catchError((e) {
      //print(e);
    });
    if (result.data != null) {
      data = result.data['data'][0];
    }
    return data;
  }

  Future<String?> getCurrentZipcode() async {
    LocationData? locationData = await getCurrentLocation();
    if (locationData == null) {
      return null;
    }
    double? lat = locationData.latitude;
    double? lon = locationData.longitude;
    String? zip = await getZipFromLatLon(lat!, lon!);
    return zip;
  }

  Future<String?> getCurrentCity() async {
    LocationData? locationData = await getCurrentLocation();
    if (locationData == null) {
      return null;
    }
    double? lat = locationData.latitude;
    double? lon = locationData.longitude;
    String? city = await getCityNameFromLatLon(lat!, lon!);
    return city;
  }

  Future<String?> getCurrentProvince() async {
    LocationData? locationData = await getCurrentLocation();
    if (locationData == null) {
      return null;
    }
    double? lat = locationData.latitude;
    double? lon = locationData.longitude;
    String? province = await getProvinceFromLatLon(lat!, lon!);
    return province;
  }

  Future<String?> getAddressFromLatLon(double lat, double lon) async {
    String? foundAddress;
    Map<dynamic, dynamic>? data = await reverseGeocodeLatLon(lat, lon);
    if (data != null) {
      foundAddress = data['formattedAddress'];
    }
    return foundAddress;
  }

  Future<String?> getZipFromLatLon(double lat, double lon) async {
    String? zip;
    Map<dynamic, dynamic>? data = await reverseGeocodeLatLon(lat, lon);
    if (data != null) {
      zip = data['zipcode'];
    }
    return zip;
  }

  Future<String?> getCityNameFromLatLon(double lat, double lon) async {
    String? cityName;
    Map<dynamic, dynamic>? data = await reverseGeocodeLatLon(lat, lon);
    if (data != null) {
      cityName = data['city'];
    }
    return cityName;
  }

  Future<String?> getProvinceFromLatLon(double lat, double lon) async {
    String? province;
    Map<dynamic, dynamic>? data = await reverseGeocodeLatLon(lat, lon);
    if (data != null) {
      province = data['administrativeLevels']['level1short'];
    }
    return province;
  }

  openMaps({required String address}) {
    MapsLauncher.launchQuery(address);
  }

  Future<bool> isNearbyLocation({required double lat, required double lon}) async {
    bool isNearby = true;
    LocationData? currentLocationData = await getCurrentLocation();
    if (currentLocationData != null) {
      double distanceInKilometers = Geolocator.distanceBetween(lat, lon, currentLocationData.latitude!, currentLocationData.longitude!);
      if (distanceInKilometers >= 1) {
        isNearby = false;
      }
    } else {
      isNearby = false;
      _customDialogService.showErrorDialog(description: "There was an issue accessing your location. Please try again");
    }

    return isNearby;
  }
}
