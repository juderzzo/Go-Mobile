import 'dart:io';
import 'dart:typed_data';

import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CommentTextFieldViewModel extends ReactiveViewModel {
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  ///USER DATA
  GoUser get user => _reactiveUserService.user;

  List<GoUser> mentionedUsers = [];

  ///IMG DATA
  File? imgFile;
  Uint8List? imgByteData;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  addUserToMentions(GoUser user) {
    mentionedUsers.add(user);
    notifyListeners();
  }

  void selectImage() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "camera") {
        imgFile = await GoImagePicker().retrieveImageFromCamera(ratioX: 1, ratioY: 1);
      } else if (res == "gallery") {
        imgFile = await GoImagePicker().retrieveImageFromLibrary(ratioX: 1, ratioY: 1);
      }
      if (imgFile != null) {
        imgByteData = await imgFile!.readAsBytes();
      }
      notifyListeners();
    }
  }

  void removeImage() {
    imgFile = null;
    imgByteData = null;
  }

  List<GoUser> getMentionedUsers({String? commentText}) {
    mentionedUsers.forEach((user) {
      if (!commentText!.contains(user.username!)) {
        mentionedUsers.remove(user);
      }
    });
    notifyListeners();
    return mentionedUsers;
  }

  clearMentionedUsers() {
    mentionedUsers = [];
    notifyListeners();
  }
}
