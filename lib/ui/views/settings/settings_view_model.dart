import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  signOut(BuildContext context) async {
    String action = await showModalActionSheet(
      message: "Are You Sure You Want to Log Out?",
      context: context,
      actions: [
        SheetAction(label: "Log Out", key: 'logout', isDestructiveAction: true),
      ],
    );
    if (action == "logout") {
      await _authService.signOut();
      _navigationService.pushNamedAndRemoveUntil(Routes.RootViewRoute);
    }
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
