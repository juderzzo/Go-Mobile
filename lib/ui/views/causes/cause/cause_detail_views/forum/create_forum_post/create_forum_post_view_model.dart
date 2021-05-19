import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateForumPostViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  PostDataService? _postDataService = locator<PostDataService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();

  ///HELPERS
  TextEditingController postTextController = TextEditingController();

  ///DATA
  bool isEditing = false;
  GoForumPost? originalPost;
  dynamic imgFile;

  String? causeID;
  String? postID;
  dynamic img;
  bool imgChanged = false;

  initialize(String cID, String pID) async {
    causeID = cID;
    postID = pID;
    if (postID != "new") {
      isEditing = true;
      originalPost = await _postDataService!.getPostByID(postID);
      if (originalPost!.imageID != null) {
        img = originalPost!.imageID;
      }
      if (img.length < 3) {
        //this will make sure if the img id is a blank string it gets turned back to null
        //from above
        img = null;
      }
      postTextController.text = originalPost!.body!;
    } else {
      postID = getRandomString(32);
    }
    notifyListeners();
  }

  Future<bool> validateAndSubmitForm() async {
    String? id;
    String? formError;
    String body = postTextController.text.trim();
    setBusy(true);
    if (!isValidString(body)) {
      formError = "Post Cannot Be Empty";
    }
    if (formError != null) {
      setBusy(false);
      _snackbarService!.showSnackbar(
        title: 'Post Submission Error',
        message: formError,
        duration: Duration(seconds: 5),
      );
      return false;
    } else {
      String? authorID = await _authService!.getCurrentUserID();
      var res;

      if (isEditing) {
        res = await _postDataService!.updatePost(
          id: originalPost!.id,
          causeID: originalPost!.causeID,
          authorID: authorID,
          body: body,
          image: img,
          dateCreatedInMilliseconds: originalPost!.dateCreatedInMilliseconds,
          commentCount: originalPost!.commentCount,
        );
      } else {
        //first upload the images
        id = getRandomString(35);
        print("view model");
        print(id);
        res = await _postDataService!.createPost(
          id: id,
          causeID: causeID,
          authorID: authorID,
          body: body,
          image: imgFile,
          dateCreatedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
          commentCount: 0,
        );
      }
      print("chungus");
      setBusy(false);
      if (res is String) {
        _snackbarService!.showSnackbar(
          title: 'Form Submission Error',
          message: res,
          duration: Duration(seconds: 5),
        );
        return false;
      } else {
        displayPostUploadSuccessBottomSheet(id);
        return true;
      }
    }
  }

  void selectImage(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    imgChanged = true;
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "camera") {
        imgFile = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
      } else if (res == "gallery") {
        imgFile = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
      }
      img = imgFile;
      notifyListeners();
    }
  }

  ///BOTTOM SHEETS
  displayPostUploadSuccessBottomSheet(String? postID) async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      variant: BottomSheetType.postPublished,
      takesInput: false,
      barrierDismissible: true,
      customData: {
        'postID': null,
      },
    );
    if (sheetResponse == null || sheetResponse.responseData == "return") {
      _navigationService!.back(result: "newPostCreated");
      // _navigationService.back();
    }
  }

  ///NAVIGATION

  pushAndReplaceUntilHomeNavView() {
    //_navigationService.pushNamedAndRemoveUntil(Routes.AppBaseViewRoute);
  }

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
