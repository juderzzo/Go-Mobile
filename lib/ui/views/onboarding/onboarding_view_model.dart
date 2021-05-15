import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_storage_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:go/services/permission_handler/permission_handler_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class OnboardingViewModel extends ReactiveViewModel {
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  PermissionHandlerService _permissionHandlerService = locator<PermissionHandlerService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  LocationService _locationService = locator<LocationService>();
  UserDataService _userDataService = locator<UserDataService>();
  ThemeService _themeService = locator<ThemeService>();

  ///USER
  GoUser get user => _reactiveUserService.user;
  String emailAddress = "";
  String username = "";
  String bio = "";

  bool isLoading = false;
  File? imgFile;
  String profilePlaceholderImgURL =
      "https://www.qualitysleepstore.com/pub/static/version1597711649/frontend/Pearl/weltpixel_custom/en_US/Magento_Catalog/images/product/placeholder/image.jpg";

  ///PERMISSIONS DATA
  bool notificationError = false;
  bool updatingLocation = false;
  bool locationError = false;
  bool hasLocation = false;

  ///INTRO STATE
  final introKey = GlobalKey<IntroductionScreenState>();
  bool showSkipButton = true;
  bool showNextButton = true;
  bool freezeSwipe = false;
  int pageNum = 0;
  int imgFlex = 3;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  initialize() {
    setBusy(true);
    _themeService.setThemeMode(ThemeManagerMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    notifyListeners();
    setBusy(false);
  }

  updatePageNum(int val) {
    pageNum = val;
    notifyListeners();
  }

  updateImgFlex(int val) {
    imgFlex = val;
    notifyListeners();
  }

  updateShowNextButton(bool val) {
    showNextButton = val;
    notifyListeners();
  }

  updateEmail(String val) {
    emailAddress = val.trim();
    notifyListeners();
  }

  updateUsername(String val) {
    username = val.trim().toLowerCase();
    notifyListeners();
  }

  updateBio(String val) {
    bio = val.trim();
    notifyListeners();
  }

  validateAndSubmitEmailAddress() {
    if (!isValidEmail(emailAddress)) {
      _customDialogService.showErrorDialog(description: "Invalid Email Address");
      return;
    } else {
      _userDataService.updateAssociatedEmailAddress(user.id!, emailAddress);
      introKey.currentState!.next();
    }
  }

  checkNotificationPermissions() async {
    bool hasPermission = await _permissionHandlerService.hasNotificationsPermission();
    if (hasPermission) {
      introKey.currentState!.next();
    } else {
      notificationError = true;
      notifyListeners();
    }
  }

  checkLocationPermissions() async {
    updatingLocation = true;
    notifyListeners();
    bool hasPermission = await _permissionHandlerService.hasLocationPermission();
    if (hasPermission) {
      introKey.currentState!.next();
    } else {
      locationError = true;
      notifyListeners();
    }
    updatingLocation = false;
    notifyListeners();
  }

  openAppSettings() {
    openAppSettings();
  }

  selectImage() async {
    String? source = await _customBottomSheetService.showImageSelectorBottomSheet();
    if (source != null) {
      //get image from camera or gallery
      if (source == "camera") {
        bool hasCameraPermission = await _permissionHandlerService.hasCameraPermission();
        if (hasCameraPermission) {
          imgFile = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
        } else {
          if (Platform.isAndroid) {
            _customDialogService.showAppSettingsDialog(
              title: "Camera Permission Required",
              description: "Please open your app settings and enable your camera",
            );
          }
        }
      } else if (source == "gallery") {
        bool hasPhotosPermission = await _permissionHandlerService.hasPhotosPermission();
        if (hasPhotosPermission) {
          imgFile = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
        } else {
          if (Platform.isAndroid) {
            _customDialogService.showAppSettingsDialog(
              title: "Storage Permission Required",
              description: "Please open your app settings and enable your access to your storage",
            );
          }
        }
      }
    }
    notifyListeners();
  }

  validateAndSubmit() async {
    isLoading = true;
    notifyListeners();
    bool usernameExists = await _userDataService.checkIfUsernameExists(username);
    print(username);
    if (usernameExists) {
      _customDialogService.showErrorDialog(description: "Username Unavailable");
      isLoading = false;
      notifyListeners();
      return;
    }
    if (username.isEmpty) {
      _customDialogService.showErrorDialog(description: "Username Required");
      isLoading = false;
      notifyListeners();
      return;
    }
    if (!isValidUsername(username)) {
      _customDialogService.showErrorDialog(description: "Invalid Username");
      isLoading = false;
      notifyListeners();
      return;
    }
    if (imgFile == null) {
      _customDialogService.showErrorDialog(description: "Profile Pic Required");
      isLoading = false;
      notifyListeners();
      return;
    }

    String? profilePicURL = await _firebaseStorageService.uploadImage(img: imgFile!, storageBucket: "images", folderName: "users", fileName: user.id!);
    if (profilePicURL == null) {
      _customDialogService.showErrorDialog(description: "There was an issue uploading your profile pic.\nPlease Try Again.");
      isLoading = false;
      notifyListeners();
      return;
    }

    GoUser currentUser = user;
    currentUser.username = username;
    currentUser.profilePicURL = profilePicURL;
    currentUser.bio = bio;
    currentUser.onboarded = true;
    bool updatedUser = await _userDataService.updateGoUser(currentUser);
    if (!updatedUser) {
      _customDialogService.showErrorDialog(description: "There was an issue unknown issue.\nPlease Try Again.");
      isLoading = false;
      notifyListeners();
      return;
    }
    _reactiveUserService.updateUser(currentUser);
    navigateToAppBase();
  }

  navigateToNextPage() {
    introKey.currentState!.next();
  }

  navigateToPreviousPage() {
    introKey.currentState!.animateScroll(pageNum - 1);
  }

  navigateToAppBase() {
    _navigationService.navigateTo(Routes.AppBaseViewRoute);
  }
}
