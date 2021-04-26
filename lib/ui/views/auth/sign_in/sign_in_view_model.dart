import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();

  String? email;
  String? password;

  updateEmail(String val) {
    email = val.trim();
    notifyListeners();
  }

  updatePassword(String val) {
    password = val;
    notifyListeners();
  }

  bool formIsValid() {
    bool isValid = true;
    if (email == null || !isValidEmail(email!)) {
      _customDialogService.showErrorDialog(description: "Email is invalid");
      isValid = false;
    } else if (password == null) {
      _customDialogService.showErrorDialog(description: "Password is invalid");
      isValid = false;
    }
    return isValid;
  }

  signInWithEmail() async {
    setBusy(true);
    if (formIsValid()) {
      bool signedIn = await _authService.signInWithEmail(email: email!, password: password!);
      if (signedIn) {
        await _authService.completeUserSignIn();
      }
    }
    setBusy(false);
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
  replaceWithSignUpPage() {
    _navigationService!.replaceWith(Routes.SignUpViewRoute);
  }

  navigateToHomePage() {
    _navigationService!.navigateTo(Routes.AppBaseViewRoute);
  }

  navigateToForgot() {
    _navigationService!.navigateTo(Routes.ForgotViewRoute);
  }
}
