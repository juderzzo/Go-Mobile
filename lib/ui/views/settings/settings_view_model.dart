import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firebase_messaging/firebase_messaging_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SettingsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ThemeService _themeService = locator<ThemeService>();
  FirebaseMessagingService _firebaseMessagingService = locator<FirebaseMessagingService>();

  bool notificationsEnabled = false;

  toggleDarkMode() {
    if (_themeService.selectedThemeMode == ThemeManagerMode.light) {
      _themeService.setThemeMode(ThemeManagerMode.dark);
    } else {
      _themeService.setThemeMode(ThemeManagerMode.light);
    }
  }

  bool isDarkMode() {
    if (_themeService.selectedThemeMode == ThemeManagerMode.light) {
      return false;
    } else {
      return true;
    }
  }


  enableNotifications() async {
    
    PermissionStatus permissionStatus = await Permission.notification.status;
    if (permissionStatus.isUndetermined) {
      permissionStatus = await Permission.notification.request();
      if (permissionStatus.isGranted) {
        notificationsEnabled = true;
        notifyListeners();
      }
    } else if (permissionStatus.isGranted) {
      notificationsEnabled = true;
      _firebaseMessagingService.configFirebaseMessaging();
      notifyListeners();
    } else if (permissionStatus.isDenied) {
      DialogResponse response = await _dialogService.showConfirmationDialog(
        title: "Enable Notifications?",
        description: "Open app settings to enable notifications",
        cancelTitle: "Cancel",
        confirmationTitle: "Open App Settings",
        barrierDismissible: true,
      );
      if (response.confirmed) {
        AppSettings.openNotificationSettings();
      }
    }
  }

  signOut(BuildContext context) async {
    String action = await showModalActionSheet(
      message: "Are You Sure You Want to Log Out?",
      context: context,
      actions: [
        SheetAction(label: "Log Out", key: 'logout', icon: Icons.logout, isDestructiveAction: true),
      ],
      title: "Logout"
    );
    if (action == "logout") {
      await _authService.signOut();
      if (_themeService.selectedThemeMode != ThemeManagerMode.light) {
        _themeService.setThemeMode(ThemeManagerMode.light);
      }
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
