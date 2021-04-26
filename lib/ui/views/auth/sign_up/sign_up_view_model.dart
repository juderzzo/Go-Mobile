import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();

  ///Sign Up Via Email
  Future signUpWithEmail({required email, required password, required confirmPassword}) async {
    //Validate Data
    bool isValid = await credentialsAreValid(email, password, confirmPassword);
    if (!isValid) {
      return;
    }

    //Attempt to Create New User
    setBusy(true);

    var result = await _authService!.signUpWithEmail(
      email: email,
      password: password,
    );

    //New User Result
    setBusy(false);

    if (result is bool) {
      if (result) {
        await _dialogService!.showConfirmationDialog(
            title: "By continuing, you agree to our terms of service and privacy policy",
            description: "The policy is linked on the bottom of this page",
            barrierDismissible: true);
        await _dialogService!.showDialog(
          title: "Email Confirmation Sent",
          description: "A Confirmation Email Was Sent to:\n$email",
        );

        replaceWithSignInPage();
      } else {
        await _dialogService!.showDialog(
          title: "Sign Up Error",
          description: "There Was an Issue Signing Up. Please Try Again",
        );
      }
    } else {
      // await _dialogService!.showDialog(
      //   title: "Sign Up Error",
      //   description: result,
      // );
    }
  }

  ///DATA VALIDATION
  Future<bool> credentialsAreValid(String email, String password, String confirmPassword) async {
    bool isValid = true;
    if (!isValidEmail(email)) {
      await _dialogService!.showDialog(
        title: "Email Error",
        description: "Please Provide a Valid Email",
      );
      isValid = false;
    } else if (password.length < 7 || password.length > 50) {
      await _dialogService!.showDialog(
        title: "Password Error",
        description: "The password must be 7-50 characters long",
      );
    } else if (!isValidPassword(password)) {
      await _dialogService!.showDialog(
        title: "Password Error",
        description: "The password must contain at least...\n\n"
            "•1 Upper Case Character\n"
            "•1 Lowercase Case Character\n"
            "•1 Number\n"
            "•1 Special character (eg. ~! @#%^&*)",
      );
      isValid = false;
    } else if (password != confirmPassword) {
      await _dialogService!.showDialog(
        title: "Password Error",
        description: "Passwords Do Not Match",
      );
      isValid = false;
    }
    return isValid;
  }

  signInWithFacebook() async {
    setBusy(true);
    bool signedIn = await _authService.signInWithFacebook();
    if (signedIn) {
      await _authService.completeUserSignIn();
    }
    setBusy(false);
  }

  signInWithApple() async {
    setBusy(true);
    bool signedIn = await _authService.signInWithApple();
    if (signedIn) {
      await _authService.completeUserSignIn();
    }
    setBusy(false);
  }

  signInWithGoogle() async {
    setBusy(true);
    bool signedIn = await _authService.signInWithGoogle();
    if (signedIn) {
      await _authService.completeUserSignIn();
    }
    setBusy(false);
  }

  ///NAVIGATION
  replaceWithSignInPage() {
    _navigationService!.replaceWith(Routes.SignInViewRoute);
  }

  navigateToHomePage() {
    _navigationService!.navigateTo(Routes.AppBaseViewRoute);
  }
}
