import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  UserDataService? _userDataService = locator<UserDataService>();

  late Map<String, dynamic> args;
  TextEditingController bioTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();

  File? updatedProfilePic;
  String? updatedBio;
  String? id;
  String? updatedUsername;
  String? initialUsername;
  String initialProfilePicURL = "";
  String initialProfileBio = "";

  initialize(BuildContext context) async {
    setBusy(true);
    await getParams(context);
    notifyListeners();
    setBusy(false);
  }

  getParams(BuildContext context) async {
    args = {}; //RouteData.of(context).arguments;
    id = args['id'] ?? "";
    GoUser user = await (_userDataService!.getGoUserByID(id) as FutureOr<GoUser>);
    initialProfilePicURL = user.profilePicURL ?? "";
    initialProfileBio = user.bio ?? "";
    initialUsername = user.username;
    bioTextController.text = initialProfileBio;
    usernameTextController.text = initialUsername!;
  }

  selectImage(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "camera") {
        updatedProfilePic = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
      } else if (res == "gallery") {
        updatedProfilePic = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
      }
      notifyListeners();
      var uploadImgStatus = await _userDataService!.updateProfilePic(id!, updatedProfilePic!);
      if (uploadImgStatus is String) {
        _snackbarService!.showSnackbar(
          title: 'Photo Upload Error',
          message: uploadImgStatus,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  updateProfile() async {
    setBusy(true);
    var res = await _userDataService!.updateBio(id, bioTextController.text.trim());
    var res2 = await _userDataService!.updateGoUserName(id, usernameTextController.text.trim());

    if (res is String) {
      _snackbarService!.showSnackbar(
        title: 'Update Error',
        message: res,
        duration: Duration(seconds: 5),
      );
    } else {
      setBusy(false);
      GoUser? user = await (_userDataService!.getGoUserByID(id) as FutureOr<GoUser?>);
      //have to display
      await _dialogService!
          .showDialog(title: "Confirmation", description: "Your profile has been updated, but it may take a minute to reflect updated results");
      replaceWithNormal();
    }
  }

  ///NAVIGATION
  ///
  replaceWithNormal() {
    _navigationService!.back();
  }
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
