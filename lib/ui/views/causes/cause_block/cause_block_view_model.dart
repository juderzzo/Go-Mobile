import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();

  String creatorUsername;
  String createProfilePicURL;
  bool isLoading = true;
  List<NetworkImage> images = [];

  initialize(String id, List<String> imageURLs) async {
    GoUser creator = await _userDataService.getGoUserByID(id);
    creatorUsername = "@" + creator.username;
    createProfilePicURL = creator.profilePicURL;
    imageURLs.forEach((url) {
      images.add(
        NetworkImage(url),
      );
    });
    isLoading = false;
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
