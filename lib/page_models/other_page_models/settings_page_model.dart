import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/locator.dart';
import 'package:go/page_models/base_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';

class SettingsPageModel extends BaseModel {
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
      _navigationService.returnToRootPage();
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
