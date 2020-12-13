import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateCauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  bool isEditing = false;
  File img1;
  File img2;
  File img3;

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

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
