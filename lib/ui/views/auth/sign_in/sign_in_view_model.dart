import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///Sign Up Via Email
  Future signInWithEmail({@required email, @required password}) async {
    setBusy(true);

    var result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        if (result) _navigationService.replaceWith(Routes.HomeNavViewRoute);
      } else {
        await _dialogService.showDialog(
          title: "Login Error",
          description: "There Was an Issue Logging In. Please Try Again",
        );
      }
    } else {
      await _dialogService.showDialog(
        title: "Login Error",
        description: result,
      );
    }
  }

  ///NAVIGATION
  replaceWithSignUpPage() {
    _navigationService.replaceWith(Routes.SignUpViewRoute);
  }

  navigateToHomePage() {
    _navigationService.navigateTo(Routes.HomeNavViewRoute);
  }
}
