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

class EditCauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  bool isEditing = false;
  dynamic img1;
  dynamic img2;
  dynamic img3;
  bool img1Changed = false;
  bool img2Changed = false;
  bool img3Changed = false;

  EditCauseViewModel({this.img1, this.img2, this.img3});

  Future<bool> validateAndSubmitForm({
    String causeID,
    String name,
    String goal,
    String why,
    String who,
    String resources,
    String charityURL,
    String videoLink,
    bool monetized,
  }) async {
    String formError;
    setBusy(true);
    if (videoLink.length < 2) {
      videoLink = null;
    }
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
    } else if (videoLink != null && !(videoLink.length < 2)) {
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
      //create the initial 3 actions

      var res = await _causeDataService.editCause(
          causeID,
          name,
          goal,
          why,
          who,
          resources,
          charityURL,
          videoLink,
          

          //link each checklist item to their id in the cause functionality

          img1,
          img2,
          img3,
          monetized,
          img1Changed,
          img2Changed,
          img3Changed);

      //now push each of the checklistItems referecne

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
      //print(img2.runtimeType);

      if (imgNum == 1) {
        img1 = img;
        img1Changed = true;
      } else if (imgNum == 2) {
        img2 = img;
        img2Changed = true;
      } else {
        img3 = img;
        img3Changed = true;
      }
      //print(img.runtimeType);
      notifyListeners();
      return img;
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
