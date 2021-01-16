import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();

  String authorUsername;
  String authorProfilePicURL;
  bool isAuthor = false;

  initialize(String authorID) async {
    setBusy(true);
    String currentUID = await _authService.getCurrentUserID();
    GoUser author = await _userDataService.getGoUserByID(authorID);
    if (currentUID == authorID) {
      isAuthor = true;
    }
    authorUsername = "@" + author.username;
    authorProfilePicURL = author.profilePicURL;
    notifyListeners();
    setBusy(false);
  }

  showOptions({GoForumPost post, VoidCallback refreshAction}) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isAuthor ? BottomSheetType.postAuthorOptions : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        String data = await _navigationService.navigateTo(Routes.CreateForumPostViewRoute, arguments: {
          'causeID': post.causeID,
          'postID': post.id,
        });
        if (data != null && data == 'newPostCreated') {
          refreshAction();
        }
      } else if (res == "share") {
        //share
      } else if (res == "report") {
        //report
      } else if (res == "delete") {
        //delete
      }
      notifyListeners();
    }
  }

  ///NAVIGATION
  navigateToPostView(String postID) {
    _navigationService.navigateTo(Routes.ForumPostViewRoute, arguments: {'postID': postID});
  }

  navigateToUserView(String uid) {
    _navigationService.navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }
}
