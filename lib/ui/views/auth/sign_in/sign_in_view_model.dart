import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();

  ///Sign Up Via Email
  Future signInWithEmail({required email, required password}) async {
    setBusy(true);

    var result = await _authService!.signInWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        bool onboarded = await (_userDataService!.checkIfUserHasBeenOnboarded(await _authService!.getCurrentUserID()) as FutureOr<bool>);

        if (!onboarded) {
          //_navigationService.replaceWith(Routes.OnboardingViewRoute);
        } else {
          _navigationService!.replaceWith(Routes.AppBaseViewRoute);
        }
      } else {
        await _dialogService!.showDialog(
          title: "Login Error",
          description: "There Was an Issue Logging In. Please Try Again",
        );
      }
    } else {
      await _dialogService!.showDialog(
        title: "Login Error",
        description: result,
      );
    }
  }

  Future loginWithFacebook() async {
    setBusy(true);

    var result = await _authService!.loginWithFacebook();

    setBusy(false);

    if (result is bool) {
      if (result) {
        String? uid = await _authService!.getCurrentUserID();
        bool onboarded = await (_userDataService!.checkIfUserHasBeenOnboarded(uid) as FutureOr<bool>);
        if (onboarded) {
          _navigationService!.replaceWith(Routes.AppBaseViewRoute);
        } else {
          //_navigationService.replaceWith(Routes.OnboardingViewRoute);
        }
      }
    }
  }

  Future loginWithApple() async {
    setBusy(true);

    var result = await _authService!.loginWithApple();

    setBusy(false);

    if (result is bool) {
      if (result) {
        String? uid = await _authService!.getCurrentUserID();
        bool onboarded = await (_userDataService!.checkIfUserHasBeenOnboarded(uid) as FutureOr<bool>);
        if (onboarded) {
          _navigationService!.replaceWith(Routes.AppBaseViewRoute);
        } else {
          // _navigationService.replaceWith(Routes.OnboardingViewRoute);
        }
      }
    }
  }

  Future loginWithGoogle() async {
    setBusy(true);

    var result = await _authService!.loginWithGoogle();

    setBusy(false);

    if (result is bool) {
      if (result) {
        String? uid = await _authService!.getCurrentUserID();
        bool onboarded = await (_userDataService!.checkIfUserHasBeenOnboarded(uid) as FutureOr<bool>);
        if (onboarded) {
          _navigationService!.replaceWith(Routes.AppBaseViewRoute);
        } else {
          //_navigationService.replaceWith(Routes.OnboardingViewRoute);
        }
      }
    }
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
