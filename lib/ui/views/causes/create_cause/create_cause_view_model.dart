import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/permission_handler/permission_handler_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CreateCauseViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  CustomBottomSheetService _customBottomSheetService = locator<CustomBottomSheetService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  PermissionHandlerService _permissionHandlerService = locator<PermissionHandlerService>();

  GoUser get user => _reactiveUserService.user;

  bool isEditing = false;
  bool isUploading = false;
  File? img1;
  File? img2;
  File? img3;
  String? imgURL1;
  String? imgURL2;
  String? imgURL3;

  GoCause cause = GoCause(monetized: false);

  ///PREVIOUS DATA IF EDITING
  bool loadedPreviousCauseName = false;
  bool loadedPreviousCauseGoal = false;
  bool loadedPreviousCauseWhy = false;
  bool loadedPreviousCauseWho = false;
  bool loadedPreviousCauseResources = false;
  bool loadedPreviousCauseWebsite = false;
  bool loadedPreviousCauseVideoLink = false;

 

  initialize(String id) async {
    setBusy(true);
    if (id != "new") {
      isEditing = true;
      cause = await _causeDataService.getCauseByID(id);
      if (cause.isValid()) {
        if (cause.imageURLs!.length >= 1) {
          imgURL1 = cause.imageURLs![0];
        }
        if (cause.imageURLs!.length >= 2) {
          imgURL2 = cause.imageURLs![1];
        }
        if (cause.imageURLs!.length >= 3) {
          imgURL3 = cause.imageURLs![2];
        }
      }
    } else {
      cause = GoCause().generateNewCause(creatorID: user.id!);
    }
    // print(cause.toMap());
    notifyListeners();
    setBusy(false);
  }

  ///LOAD PREVIOUS DATA FOR EDITING
  String loadPreviousCauseName() {
    loadedPreviousCauseName = true;
    notifyListeners();
    return cause.name ?? "";
    
  }

  String loadPreviousCauseGoal() {
    loadedPreviousCauseGoal = true;
    notifyListeners();
    return cause.goal ?? "";
  }

  

  String loadPreviousCauseWhy() {
    loadedPreviousCauseWhy = true;
    notifyListeners();
    return cause.why ?? "";
  }

  String loadPreviousCauseWho() {
    loadedPreviousCauseWho = true;
    notifyListeners();
    return cause.who ?? "";
  }

  String loadPreviousCauseResources() {
    loadedPreviousCauseResources = true;
    notifyListeners();
    return cause.resources ?? "";
  }

  String loadPreviousCauseWebsite() {
    loadedPreviousCauseWebsite = true;
    notifyListeners();
    return cause.website ?? "";
  }

  String loadPreviousCauseVideoLink() {
    loadedPreviousCauseVideoLink = true;
    notifyListeners();
    return cause.videoLink ?? "";
  }

  ///UPDATE DATA
  updateCauseName(String val) {
    cause.name = val.trim();
    notifyListeners();
  }

  updateCauseGoal(String val) {
    cause.goal = val.trim();
    notifyListeners();
  }

  updateCauseWhy(String val) {
    cause.why = val.trim();
    notifyListeners();
  }

  updateCauseWho(String val) {
    cause.who = val.trim();
    notifyListeners();
  }

  updateCauseResources(String val) {
    cause.resources = val.trim();
    notifyListeners();
  }

  updateCauseWebsite(String val) {
    cause.website = val.trim();
    notifyListeners();
  }

  updateCauseVideoLink(String val) {
    cause.videoLink = val.trim();
    notifyListeners();
  }

  updateCauseMonetization(bool val) {
    cause.monetized = val;
    notifyListeners();
  }

  validateAndSubmitForm() async {
    String? formError;
    if (cause.videoLink != null && cause.videoLink!.length < 2) {
      cause.videoLink = "";
    }
    isUploading = true;
    notifyListeners();
    if (!isValidString(cause.name)) {
      formError = "Cause Name Required";
    } else if (!isValidString(cause.goal)) {
      formError = "Please list your causes's goals";
    } else if (!isValidString(cause.why)) {
      formError = "Please describe why your cause is important";
    } else if (!isValidString(cause.who)) {
      formError = "Please describe who you are in regards to this cause";
    } else if (isValidString(cause.charityURL) && !UrlHandler().isValidUrl(cause.charityURL!)) {
      formError = "Please provide a valid URL your cause";
    } else if (img1 == null && img2 == null && img3 == null && cause.videoLink == null){
      formError = "Please provide atleast one image or youtube video for your cause";
    } else if (cause.videoLink != null && !(cause.videoLink!.length < 2)) {
      if (YoutubePlayer.convertUrlToId(cause.videoLink!) == null) {
        formError = "Please provide a valid youtube link or leave the field blank";
      }
    }
    if (formError != null) {
      isUploading = false;
      notifyListeners();
      _dialogService.showDialog(
        title: "Form Error",
        description: formError,
        barrierDismissible: true,
      );
      return false;
    } else {
      bool uploaded = true;
      if (isEditing) {
        uploaded = await _causeDataService.updateCause(cause: cause, img1: img1, img2: img2, img3: img3);
      } else {
        uploaded = await _causeDataService.createCause(cause: cause, img1: img1, img2: img2, img3: img3);
      }

      isUploading = false;
      notifyListeners();

      if (uploaded) {
        _customBottomSheetService.showCausePublishedBottomSheet(cause);
      }
    }
  }

  ///BOTTOM SHEETS
  selectImage({required BuildContext context, int? imgNum, double? ratioX, double? ratioY}) async {
    File? img;
    FocusScope.of(context).requestFocus(FocusNode());
    String? source = await _customBottomSheetService.showImageSelectorBottomSheet();
    if (source != null) {
      //get image from camera or gallery
      if (source == "camera") {
        bool hasCameraPermission = await _permissionHandlerService.hasCameraPermission();
        if (hasCameraPermission) {
          img = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
        }
      } else if (source == "gallery") {
        bool hasPhotosPermission = await _permissionHandlerService.hasPhotosPermission();
        if (hasPhotosPermission) {
          img = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
        }
      }
    }
    if (imgNum == 1) {
      img1 = img;
    } else if (imgNum == 2) {
      img2 = img;
    } else {
      img3 = img;
    }
    notifyListeners();
  }
}
