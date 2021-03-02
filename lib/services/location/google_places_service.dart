import 'package:auto_route/auto_route.dart';
import 'package:flutter_google_places_api/flutter_google_places_api.dart';
import 'package:flutter_google_places_api/requests/place_autocomplete_request.dart';
import 'package:flutter_google_places_api/responses/place_autocomplete_response.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/firestore/platform_data_service.dart';

import 'location_service.dart';

class GooglePlacesService {
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  LocationService _locationService = locator<LocationService>();

  Future googleSearchAutoComplete({@required String input}) async {
    String key = await _platformDataService.getGoogleApiKey().catchError((e) {});
    Map<String, dynamic> places = {};
    PlaceAutocompleteResponse response = await PlaceAutocompleteRequest(
      key: key,
      input: input,
    ).call();
    response.predictions.forEach((res) {
      places[res.description] = res.placeId;
    });
    return places;
  }

  Future<Map<String, dynamic>> getLatLonFromPlaceID({@required String placeID}) async {
    String key = await _platformDataService.getGoogleApiKey().catchError((e) {});
    Map<String, dynamic> coordinates = {};
    PlaceDetailsResponse response = await PlaceDetailsRequest(
      key: key,
      placeId: placeID,
    ).call();
    if (response.status.errorMessage == null) {
      coordinates['lat'] = response.result.geometry.location.lat;
      coordinates['lon'] = response.result.geometry.location.lng;
    }
    return coordinates;
  }
}
