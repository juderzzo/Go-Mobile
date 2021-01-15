import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();
  PostDataService _postDataService = locator<PostDataService>();

  ///DATA
  String authorUsername;
  String authorProfilePicURL;
  GoUser author;
  GoForumPost post;
  bool isAuthor = false;

  initialize(BuildContext context) async {
    setBusy(true);
    String currentUID = await _authService.getCurrentUserID();

    Map<String, dynamic> args = RouteData.of(context).arguments;
    String postID = args['postID'] ?? "";

    var res = await _postDataService.getPostByID(postID);
    if (res is String) {
    } else {
      post = res;
    }
    GoUser author = await _userDataService.getGoUserByID(post.authorID);
    if (currentUID == post.authorID) {
      isAuthor = true;
    }
    authorUsername = "@" + author.username;
    authorProfilePicURL = author.profilePicURL;
    notifyListeners();
    setBusy(false);
  }

  showOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isAuthor ? BottomSheetType.postAuthorOptions : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        //edit
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
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
