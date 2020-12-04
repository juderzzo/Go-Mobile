import 'package:flutter/cupertino.dart';
import 'package:go/locator.dart';
import 'package:go/routes/route_names.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';

import 'base_model.dart';

class SignInPageModel extends BaseModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///Sign Up Via Email
  Future signInWithEmail({@required email, @required password}) async {
    setBusy(true);

    var result = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomePageRoute);
      } else {
        await _dialogService.showDialog(
          title: "Sign Up Error",
          description: "There Was an Issue Signing Up. Please Try Again",
        );
      }
    } else {
      await _dialogService.showDialog(
        title: "Sign Up Error",
        description: result,
      );
    }
  }

  ///NAVIGATION
  replaceWithSignUpPage() {
    _navigationService.replaceWith(SignUpPageRoute);
  }

  navigateToHomePage() {
    _navigationService.navigateTo(HomePageRoute);
  }
}
