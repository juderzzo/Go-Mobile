import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/utils/random_string_generator.dart';
import 'package:go/utils/string_validator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateForumPostViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PostDataService _postDataService = locator<PostDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  ///HELPERS
  TextEditingController postTextController = TextEditingController();

  ///DATA
  bool isEditing = false;
  GoForumPost originalPost;
  File imgFile;

  String causeID;
  String postID;

  initialize(BuildContext context) async {
    Map<String, dynamic> args = RouteData.of(context).arguments;
    causeID = args['causeID'];
    postID = args['postID'];
    if (postID != null) {
      isEditing = true;
      originalPost = await _postDataService.getPostByID(postID);
      postTextController.text = originalPost.body;
      notifyListeners();
    }
  }

  Future<bool> validateAndSubmitForm() async {
    String formError;
    String body = postTextController.text.trim();
    setBusy(true);
    if (!StringValidator().isValidString(body)) {
      formError = "Post Cannot Be Empty";
    }
    if (formError != null) {
      setBusy(false);
      _snackbarService.showSnackbar(
        title: 'Post Submission Error',
        message: formError,
        duration: Duration(seconds: 5),
      );
      return false;
    } else {
      String authorID = await _authService.getCurrentUserID();
      var res;

      if (isEditing) {
        res = await _postDataService.createPost(
          id: originalPost.id,
          causeID: originalPost.causeID,
          authorID: authorID,
          body: body,
          dateCreatedInMilliseconds: originalPost.dateCreatedInMilliseconds,
          commentCount: originalPost.commentCount,
        );
      } else {
        //first upload the images
        String id = getRandomString(35);

        res = await _postDataService.createPost(
          id: id,
          causeID: causeID,
          authorID: authorID,
          body: body,
          image: imgFile,
          dateCreatedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
          commentCount: 0,
        );
      }
      setBusy(false);
      if (res is String) {
        _snackbarService.showSnackbar(
          title: 'Form Submission Error',
          message: res,
          duration: Duration(seconds: 5),
        );
        return false;
      } else {
        return true;
      }
    }
  }

  void selectImage() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "camera") {
        imgFile =
            await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
      } else if (res == "gallery") {
        imgFile = await GoImagePicker()
            .retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
      }
      notifyListeners();
    }
  }

  ///BOTTOM SHEETS
  displayPostUploadSuccessBottomSheet() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.postPublished,
      takesInput: false,
      barrierDismissible: true,
      customData: {
        'postID': null,
      },
    );
    if (sheetResponse == null || sheetResponse.responseData == "return") {
      _navigationService.back(result: "newPostCreated");
      _navigationService.back();
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
