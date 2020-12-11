import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RootViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  UserDataService _userDataService = locator<UserDataService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///CHECKS IF USER IS LOGGED IN
  Future checkAuthState() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      ///CHECK IF USER HAS CREATED PROFILE
      String uid = await _authService.getCurrentUserID();
      print(uid);
      bool goUserExists = await _userDataService.checkIfUserExists(uid);
      if (goUserExists) {
        _navigationService.replaceWith(Routes.HomeNavViewRoute);
      } else {
        _navigationService.replaceWith(Routes.OnboardingViewRoute);
      }
    } else {
      _navigationService.replaceWith(Routes.SignInViewRoute);
    }
  }
}