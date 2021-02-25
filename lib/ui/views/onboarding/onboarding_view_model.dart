import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class OnboardingViewModel extends BaseViewModel {
  ///SERVICES
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  ThemeService _themeService = locator<ThemeService>();

  ///HELPERS
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();

  String profilePlaceholderImgURL =
      "https://www.qualitysleepstore.com/pub/static/version1597711649/frontend/Pearl/weltpixel_custom/en_US/Magento_Catalog/images/product/placeholder/image.jpg";

  ///DATA
  String uid;
  File imgFile;
  bool notificationsEnabled = false;

  initialize() async {
    setBusy(true);
    uid = await _authService.getCurrentUserID();
    notifyListeners();
    setBusy(false);
  }

  selectImage(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "camera") {
        imgFile =
            await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
      } else if (res == "gallery") {
        imgFile = await GoImagePicker()
            .retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
      }
      notifyListeners();
      var uploadImgStatus =
          await _userDataService.updateProfilePic(uid, imgFile);
      if (uploadImgStatus is String) {
        _snackbarService.showSnackbar(
          title: 'Photo Upload Error',
          message: uploadImgStatus,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  Future<bool> completeProfilePicUsernamePage() async {
    bool complete = false;
    setBusy(true);
    if (imgFile == null) {
      _snackbarService.showSnackbar(
        title: 'Photo Missing',
        message: 'Please Select an Image for Your Profile',
        duration: Duration(seconds: 5),
      );
    } else {
      String username = usernameTextController.text.trim().toLowerCase();
      if (username.isEmpty) {
        _snackbarService.showSnackbar(
          title: 'Username Missing',
          message: 'Please add a username',
          duration: Duration(seconds: 5),
        );
      } else {
        bool usernameExists =
            await _userDataService.checkIfUsernameExists(uid, username);
        if (usernameExists) {
          _snackbarService.showSnackbar(
            title: 'Username Taken',
            message: 'This username has already been taken',
            duration: Duration(seconds: 5),
          );
        } else {
          var res = await _userDataService.updateGoUserName(uid, username);
          if (res is String) {
            _snackbarService.showSnackbar(
              title: 'Uh-Oh...',
              message: res,
              duration: Duration(seconds: 5),
            );
          }
          complete = true;
        }
      }
    }
    setBusy(false);
    return complete;
  }

  Future<bool> completeBio() async {
    String bio = bioTextController.text.trim();
    if (bio.isEmpty) {
      _snackbarService.showSnackbar(
        title: 'Bio Error',
        message: 'Bio cannot be empty',
        duration: Duration(seconds: 5),
      );
      return false;
    }
    setBusy(true);
    var res = await _userDataService.updateBio(uid, bio);
    setBusy(false);
    if (res is String) {
      _snackbarService.showSnackbar(
        title: 'Uh-Oh...',
        message: res,
        duration: Duration(seconds: 5),
      );
      return false;
    }
    return true;
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

  completeOnboarding() async {
    setBusy(true);
    var res = await _userDataService.updateUserOnboardStatus(uid);
    setBusy(false);
    if (res is String) {
      _snackbarService.showSnackbar(
        title: 'Uh-Oh...',
        message: res,
        duration: Duration(seconds: 5),
      );
    } else {
      replaceWithHomeNavView();
    }
  }

  ///NAVIGATION
  replaceWithHomeNavView() {
    _navigationService.replaceWith(Routes.HomeNavViewRoute);
  }

  static  signOut() async {
    AuthService _authService = locator<AuthService>();
    ThemeService _themeService = locator<ThemeService>();
    NavigationService _navigationService = locator<NavigationService>();
  
      

        await _authService.signOut();
        if (_themeService.selectedThemeMode != ThemeManagerMode.light) {
          _themeService.setThemeMode(ThemeManagerMode.light);
        }
        _navigationService.pushNamedAndRemoveUntil(Routes.RootViewRoute);
      }
    
}
