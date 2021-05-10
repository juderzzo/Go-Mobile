import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_storage_service.dart';
import 'package:go/services/permission_handler/permission_handler_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends ReactiveViewModel {
  NavigationService? _navigationService = locator<NavigationService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  UserDataService _userDataService = locator<UserDataService>();
  PermissionHandlerService _permissionHandlerService = locator<PermissionHandlerService>();
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();

  bool updatingData = false;

  ///USER DATA
  GoUser get user => _reactiveUserService.user;

  ///FILE DATA
  File? updatedProfilePicFile;

  String? updatedBio;
  String initialProfilePicURL = "";
  String initialProfileBio = "";
  String initialWebsiteLink = "";

  ///REACTIVE SERVICES
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  initialize(BuildContext context) async {
    setBusy(true);
    usernameTextController.text = user.username ?? "";
    initialProfilePicURL = user.profilePicURL ?? "";
    bioTextController.text = user.bio ?? "";
    websiteTextController.text = user.personalSite ?? "";
    notifyListeners();
    setBusy(false);
  }

  selectImage() async {
    String? source = await _customBottomSheetService.showImageSelectorBottomSheet();
    if (source != null) {
      //get image from camera or gallery
      if (source == "camera") {
        bool hasCameraPermission = await _permissionHandlerService.hasCameraPermission();
        if (hasCameraPermission) {
          updatedProfilePicFile = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
        }
      } else if (source == "gallery") {
        bool hasPhotosPermission = await _permissionHandlerService.hasPhotosPermission();
        if (hasPhotosPermission) {
          updatedProfilePicFile = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
        }
      }

      notifyListeners();

      if (updatedProfilePicFile != null) {
        String? imageURL =
            await _firebaseStorageService.uploadImage(img: updatedProfilePicFile!, storageBucket: "images", folderName: "users", fileName: user.id!);
        if (imageURL != null) {
          await _userDataService.updateProfilePicURL(id: user.id!, url: imageURL);
        }
      }
    }
  }

  websiteIsValid() {
    bool isValid = isValidUrl(websiteTextController.text.trim());
    if (!isValid) {
      _snackbarService!.showSnackbar(
        title: 'Website Error',
        message: 'Please provide a valid website URL.',
        duration: Duration(seconds: 5),
      );
    }
    return isValid;
  }

  updateProfile() async {
    updatingData = true;
    notifyListeners();
    bool updateSuccessful = true;

    //update bio
    updateSuccessful = await _userDataService.updateBio(user.id!, bioTextController.text.trim());

    //update website link
    if (websiteTextController.text.trim().isNotEmpty) {
      if (websiteIsValid()) {
        updateSuccessful = await _userDataService.updatePersonalSite(id: user.id!, website: websiteTextController.text.trim());
      } else {
        updateSuccessful = false;
      }
    } else if (websiteTextController.text.trim().isEmpty) {
      updateSuccessful = await _userDataService.updatePersonalSite(id: user.id!, website: websiteTextController.text.trim());
    }

    //update username
    if (user.username != usernameTextController.text) {
      String username = usernameTextController.text.trim().toLowerCase();
      if (isValidUsername(username)) {
        updateSuccessful = await _userDataService.updateUsername(username: username, id: user.id!);
      } else {
        _customDialogService.showErrorDialog(
          description: "Invalid Username",
        );
        updatingData = false;
        notifyListeners();
        return false;
      }
      if (!updateSuccessful) {
        updatingData = false;
        notifyListeners();
        return false;
      }
    }

    if (updateSuccessful) {
      navigateBack();
    } else {
      updatingData = false;
      notifyListeners();
    }
  }

  ///NAVIGATION
  navigateBack() {
    _navigationService!.back();
  }
}
