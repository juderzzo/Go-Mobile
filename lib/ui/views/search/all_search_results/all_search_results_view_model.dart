import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllSearchResultsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();

  initialize(BuildContext context, String searchTerm) {
    searchTextController.text = searchTerm;
    notifyListeners();
  }

  ///NAVIGATION
  navigateToPreviousPage() {
    _navigationService.back();
  }

  navigateToHomePage() {
    _navigationService.popRepeated(2);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}