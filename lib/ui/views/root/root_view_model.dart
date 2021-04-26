import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class RootViewModel extends BaseViewModel {
  ThemeService _themeService = locator<ThemeService>();
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///CHECKS IF USER IS LOGGED IN
  Future checkAuthState() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      bool completedSignIn = await _authService.completeUserSignIn();
      if (!completedSignIn) {
        navigateToSignIn();
      }
    } else {
      navigateToSignIn();
    }
  }

  navigateToSignIn() {
    _themeService.setThemeMode(ThemeManagerMode.light);
    notifyListeners();
    _navigationService.replaceWith(Routes.SignInViewRoute);
  }
}
