import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  GoUser currentUser;

  initialize() async {
    setBusy(true);
    var uid = await _authService.getCurrentUserID();
    if (uid != null) {
      var getUserResult = await _userDataService.getGoUserByID(uid);
      if (getUserResult is String) {
        _dialogService.showDialog(title: "Error", description: getUserResult, barrierDismissible: true, buttonTitle: "Ok");
      } else {
        currentUser = getUserResult;
      }
    } else {
      _dialogService.showDialog(title: "Unknown Error", description: "Please Try Again Later", barrierDismissible: true, buttonTitle: "Ok");
    }
    setBusy(false);
    //notifyListeners();
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToSettingsPage() {
    _navigationService.navigateTo(Routes.SettingsViewRoute);
  }
}
