import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  resetPass(email) async {
    bool sent = await _authService.sendPasswordResetEmail(email);
    if (sent) {
      await _dialogService.showDialog(
        title: "Reset",
        description:
            "A link has been sent to your email to reset your password",
      );

      replaceWithSignInPage();
    } else {
      await _dialogService.showDialog(
        title: "Email",
        description: "Please enter a valid email",
      );
    }
  }

  replaceWithSignInPage() {
    _navigationService.replaceWith(Routes.SignInViewRoute);
  }

  navigateBack() {
     _navigationService.replaceWith(Routes.SignInViewRoute);
    
  }
}
