import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();

  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  CommentDataService _commentDataService = locator<CommentDataService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  String authorUsername;
  String authorProfilePicURL;
  bool isAuthor = false;
  bool isAdmin = false;
  bool likedPost = false;

  initialize(String authorID, String causeID, String postID) async {
    setBusy(true);
    String currentUID = await _authService.getCurrentUserID();

    GoUser user = await _userDataService.getGoUserByID(currentUID);
    likedPost = user.liked.contains(postID);

    GoUser author = await _userDataService.getGoUserByID(authorID);
    if (currentUID == authorID) {
      isAuthor = true;
    }

    GoCause cause = await _causeDataService.getCauseByID(causeID);
    isAdmin = currentUID == cause.creatorID;
    print(isAdmin);
    //this is the admin part

    authorUsername = "@" + author.username;
    authorProfilePicURL = author.profilePicURL;
    notifyListeners();
    setBusy(false);
  }

  likeUnlikePost(String postID) async {
    String currentUID = await _authService.getCurrentUserID();
    _userDataService.likeUnlikePost(currentUID, postID);
    likedPost = !likedPost;
    print(likedPost);
    notifyListeners();
  }

  showOptions({GoForumPost post, VoidCallback refreshAction}) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isAuthor || isAdmin
          ? BottomSheetType.postAuthorOptions
          : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      //print(res);
      if (res == "edit") {
        String data = await _navigationService
            .navigateTo(Routes.CreateForumPostViewRoute, arguments: {
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
        if (isAuthor) {
          delete(post.id);
        }
      } else if (res == "delete") {
        //delete

      }
      notifyListeners();
    }
  }

  delete(id) async {
    _postDataService.deletePost(id);
    notifyListeners();
  }

  ///NAVIGATION
  navigateToPostView(String postID) {
    _navigationService
        .navigateTo(Routes.ForumPostViewRoute, arguments: {'postID': postID});
  }

  navigateToUserView(String uid) {
    _navigationService
        .navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }
}
