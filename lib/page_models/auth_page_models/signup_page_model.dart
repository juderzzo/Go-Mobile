import 'package:flutter/cupertino.dart';
import 'package:go/locator.dart';
import 'package:go/routes/route_names.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';
import 'package:go/utils/string_validator.dart';

import '../base_model.dart';

class SignUpPageModel extends BaseModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///Sign Up Via Email
  Future signUpWithEmail({@required email, @required password, @required confirmPassword}) async {
    //Validate Data
    bool isValid = await credentialsAreValid(email, password, confirmPassword);
    if (!isValid) {
      return;
    }

    //Attempt to Create New User
    setBusy(true);

    var result = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );

    //New User Result
    setBusy(false);

    if (result is bool) {
      if (result) {
        await _dialogService.showDialog(
          title: "Email Confirmation Sent",
          description: "A Confirmation Email Was Sent to:\n$email",
        );
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

  ///DATA VALIDATION
  Future<bool> credentialsAreValid(String email, String password, String confirmPassword) async {
    bool isValid = true;
    if (!StringValidator().isValidEmail(email)) {
      await _dialogService.showDialog(
        title: "Email Error",
        description: "Please Provide a Valid Email",
      );
      isValid = false;
    } else if (password.length < 7 || password.length > 50) {
      await _dialogService.showDialog(
        title: "Password Error",
        description: "The password must be 7-50 characters long",
      );
    } else if (!StringValidator().isValidPassword(password)) {
      await _dialogService.showDialog(
        title: "Password Error",
        description: "The password must contain at least...\n\n"
            "•1 Upper Case Character\n"
            "•1 Lowercase Case Character\n"
            "•1 Number\n"
            "•1 Special character (eg. ~! @#%^&*)",
      );
      isValid = false;
    } else if (password != confirmPassword) {
      await _dialogService.showDialog(
        title: "Password Error",
        description: "Passwords Do Not Match",
      );
      isValid = false;
    }
    return isValid;
  }

  ///NAVIGATION
  replaceWithSignInPage() {
    _navigationService.replaceWith(SignInPageRoute);
  }

  navigateToHomePage() {
    _navigationService.navigateTo(HomePageRoute);
  }
}
