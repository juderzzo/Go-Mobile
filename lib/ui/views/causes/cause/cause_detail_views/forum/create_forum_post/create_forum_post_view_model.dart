import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/utils/string_validator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateForumPostViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  bool isEditing = false;
  File img1;
  File img2;
  File img3;

  String causeID;

  initialize(BuildContext context) {
    Map<String, dynamic> args = RouteData.of(context).arguments;
    causeID = args['causeID'];
  }

  Future<bool> validateAndSubmitForm({
    String post,
  }) async {
    String formError;
    setBusy(true);
    if (!StringValidator().isValidString(post)) {
      formError = "Post Cannot Be Empty";
    }
    if (formError != null) {
      setBusy(false);
      _snackbarService.showSnackbar(
        title: 'Form Submission Error',
        message: formError,
        duration: Duration(seconds: 5),
      );
      return false;
    } else {
      String creatorID = await _authService.getCurrentUserID();
      // var res = await _causeDataService.createCause(
      //   creatorID: creatorID,
      //   name: name,
      //   goal: goal,
      //   why: why,
      //   who: who,
      //   resources: resources,
      //   charityURL: charityURL,
      //   actions: [action1, action2, action3],
      //   img1: img1,
      //   img2: img2,
      //   img3: img3,
      // );
      setBusy(false);
      // if (res != null) {
      //   _snackbarService.showSnackbar(
      //     title: 'Form Submission Error',
      //     message: formError,
      //     duration: Duration(seconds: 5),
      //   );
      //   return false;
      // } else {
      //   return true;
      // }
      return true;
    }
  }

  ///BOTTOM SHEETS
  selectImage({BuildContext context, int imgNum, double ratioX, double ratioY}) async {
    File img;
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse.responseData != null) {
      String res = sheetResponse.responseData;
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
