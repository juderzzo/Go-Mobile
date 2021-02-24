import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_checklist_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/utils/random_string_generator.dart';
import 'package:go/utils/string_validator.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CreateCauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  bool isEditing = false;
  File img1;
  File img2;
  File img3;

  GoCause cause;

  Future<bool> validateAndSubmitForm(
      {String name,
      String goal,
      String why,
      String who,
      String resources,
      String charityURL,
      String videoLink,
      bool monetized}) async {
    String formError;
    if (videoLink.length < 2) {
      videoLink = null;
    }
    setBusy(true);
    if (!StringValidator().isValidString(name)) {
      formError = "Cause Name Required";
    } else if (!StringValidator().isValidString(goal)) {
      formError = "Please list your causes's goals";
    } else if (!StringValidator().isValidString(why)) {
      formError = "Please describe why your cause is important";
    } else if (!StringValidator().isValidString(who)) {
      formError = "Please describe who you are in regards to this cause";
    } else if (StringValidator().isValidString(charityURL) &&
        !UrlHandler().isValidUrl(charityURL)) {
      formError = "Please provide a valid URL your cause";
    } else if (img1 == null){
      formError = "Please fill in the left most image for your cause";
    }

    else if (videoLink != null && !(videoLink.length < 2)) {
      print(videoLink.length);
      if (YoutubePlayer.convertUrlToId(videoLink) == null) {
        formError =
            "Please provide a valid youtube link or leave the field blank";
      }
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

      //create the initial 3 actions

      var res = await _causeDataService.createCause(
          creatorID: creatorID,
          name: name,
          goal: goal,
          why: why,
          who: who,
          resources: resources,
          charityURL: charityURL,
          //link each checklist item to their id in the cause functionality
          actions: [],
          monetized: monetized,
          img1: img1,
          img2: img2,
          img3: img3,
          videoLink: videoLink);

      
      
      setBusy(false);
      if (res != null) {
        _dialogService.showDialog(
          title: "Form Submission Error",
          description: res,
          barrierDismissible: true,
        );
        return false;
      } else {
        
        pushAndReplaceUntilHomeNavView();
        _dialogService.showConfirmationDialog(title: 'Approval', description: 'Your cause will be submitted for review. Upon acceptance, it will be visible in your homepage. Review times typically take less than 24 hours');
        return true;
      }
    }
  }

  ///BOTTOM SHEETS
  selectImage(
      {BuildContext context, int imgNum, double ratioX, double ratioY}) async {
    File img;
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse.responseData != null) {
      String res = sheetResponse.responseData;
      if (res == "camera") {
        img = await GoImagePicker()
            .retrieveImageFromCamera(ratioX: ratioX, ratioY: ratioY);
      } else if (res == "gallery") {
        img = await GoImagePicker()
            .retrieveImageFromLibrary(ratioX: ratioX, ratioY: ratioY);
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

  displayCauseUploadSuccessBottomSheet() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.causePublished,
      takesInput: false,
      barrierDismissible: true,
      customData: {
        'causeID': null,
      },
    );
    if (sheetResponse == null || sheetResponse.responseData != "return") {
      _navigationService.pushNamedAndRemoveUntil(Routes.HomeNavViewRoute);
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
