import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  sendResetEmail(email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      _dialogService.showDialog(
          title: "Account",
          description: "An email has been sent to your account");
    } catch (e) {
      _dialogService.showDialog(
          title: "Account", description: "Please use a valid email address");
      return;
    }
  }

  navigateBack() {
    _navigationService.back();
  }
}
