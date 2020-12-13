import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/utils/string_validator.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateCauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  bool isEditing = false;
  File img1;
  File img2;
  File img3;

  GoCause cause;

  selectImg({BuildContext context, int imgNum, double ratioX, double ratioY}) async {
    File img;
    String res = await showModalActionSheet(
      context: context,
      message: "Add Image",
      actions: [
        SheetAction(label: "Camera", key: 'camera', icon: FontAwesomeIcons.camera),
        SheetAction(label: "Gallery", key: 'gallery', icon: FontAwesomeIcons.image),
      ],
    );
    if (res == "camera") {
      img = await GoImagePicker().retrieveImageFromCamera(ratioX: ratioX, ratioY: ratioY);
    } else if (res == "gallery") {
      img = await GoImagePicker().retrieveImageFromLibrary(ratioX: ratioX, ratioY: ratioY);
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

  Future<bool> validateAndSubmitForm({
    String name,
    String goal,
    String why,
    String who,
    String resources,
    String charityURL,
    String action1,
    String action2,
    String action3,
  }) async {
    String formError;
    setBusy(true);
    if (!StringValidator().isValidString(name)) {
      formError = "Cause Name Required";
    } else if (!StringValidator().isValidString(goal)) {
      formError = "Please list your causes's goals";
    } else if (!StringValidator().isValidString(why)) {
      formError = "Please describe why your cause is important";
    } else if (!StringValidator().isValidString(who)) {
      formError = "Please describe who you are in regards to this cause";
    } else if (!StringValidator().isValidString(resources)) {
      formError = "Please provide additional resources for your cause";
    } else if (StringValidator().isValidString(charityURL) && !UrlHandler().isValidUrl(charityURL)) {
      formError = "Please provide a valid URL your cause";
    } else if (!StringValidator().isValidString(action1) || !StringValidator().isValidString(action2) || !StringValidator().isValidString(action3)) {
      formError = "Please provide 3 actions for your causes's followers to do";
    }
    if (formError != null) {
      setBusy(false);
      _dialogService.showDialog(
        title: "Form Error",
        description: formError,
        barrierDismissible: true,
      );
      return false;
    } else {
      String creatorID = await _authService.getCurrentUserID();
      var res = await _causeDataService.createCause(
        creatorID: creatorID,
        name: name,
        goal: goal,
        why: why,
        who: who,
        resources: resources,
        charityURL: charityURL,
        actions: [action1, action2, action3],
        img1: img1,
        img2: img2,
        img3: img3,
      );
      setBusy(false);
      if (res != null) {
        _dialogService.showDialog(
          title: "Form Submission Error",
          description: res,
          barrierDismissible: true,
        );
        return false;
      } else {
        return true;
      }
    }
  }

  ///NAVIGATION
  pushAndReplaceUntilHomeNavView() {
    _navigationService.pushNamedAndRemoveUntil(Routes.HomeNavViewRoute);
  }

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
