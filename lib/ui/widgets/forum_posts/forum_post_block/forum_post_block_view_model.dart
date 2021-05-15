import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/comment_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostBlockViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();

  NavigationService? _navigationService = locator<NavigationService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  UserDataService? _userDataService = locator<UserDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  CommentDataService? _commentDataService = locator<CommentDataService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  DynamicLinkService? _dynamicLinkService = locator<DynamicLinkService>();
  CustomNavigationService customNavigationService = locator<CustomNavigationService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  ShareService? _shareService = locator<ShareService>();
  DialogService? _dialogService = locator<DialogService>();

  String? authorUsername;
  String? authorProfilePicURL;
  bool isAuthor = false;
  bool isAdmin = false;
  bool likedPost = false;

  initialize(String? authorID, String? causeID, GoForumPost post) async {
    setBusy(true);
    String? currentUID = await _authService!.getCurrentUserID();

    likedPost = post.likedBy == null ? false : post.likedBy!.contains(_reactiveUserService.user.id);

    GoUser author = await _userDataService!.getGoUserByID(authorID);
    if (currentUID == authorID) {
      isAuthor = true;
    }

    GoCause cause = await _causeDataService!.getCauseByID(causeID);
    isAdmin = currentUID == cause.creatorID;

    //this is the admin part

    authorUsername = "@" + author.username!;
    authorProfilePicURL = author.profilePicURL;
    notifyListeners();
    setBusy(false);
  }

  showImage(Widget image, context) {
    // print(image);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: image,
          );
        });
  }

  likeUnlikePost(String postID) async {
    if (likedPost) {
      likedPost = false;
      _postDataService.unlikePost(uid: _reactiveUserService.user.id!, postID: postID);
    } else {
      likedPost = true;
      _postDataService.likePost(uid: _reactiveUserService.user.id!, postID: postID);
    }
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  showOptions({GoForumPost? post, VoidCallback? refreshAction}) async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      variant: isAuthor || isAdmin ? BottomSheetType.postAuthorOptions : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      //print(res);
      if (res == "edit") {
        // String data = await _navigationService.navigateTo(Routes.CreateForumPostViewRoute, arguments: {
        //   'causeID': post.causeID,
        //   'postID': post.id,
        // });
        // if (data != null && data == 'newPostCreated') {
        //   refreshAction();
        // }
      } else if (res == "share") {
        //share post link
        String url = await _dynamicLinkService!.createPostLink(postAuthorUsername: "$authorUsername", post: post!);
        _shareService!.shareLink(url);
      } else if (res == "report") {
        //report
        if (isAuthor || isAdmin) {
          delete(post!.id);
        }
      } else if (res == "delete") {
        //delete

      }
      notifyListeners();
    }
  }

  delete(id) async {
    _postDataService!.deletePost(id);
    notifyListeners();
  }
}
