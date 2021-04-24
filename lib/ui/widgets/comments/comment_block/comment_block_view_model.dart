import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CommentBlockViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  CommentDataService? _commentDataService = locator<CommentDataService>();

  GoUser? user;
  bool showingReplies = false;
  String? currentUID = "";

  initialize(String? uid) async {
    setBusy(true);
    var res = await _userDataService!.getGoUserByID(uid);
    if (res is String) {
    } else {
      user = res;
    }
    currentUID = await _authService!.getCurrentUserID();
    notifyListeners();
    setBusy(false);
  }

  toggleShowReplies() {
    if (showingReplies) {
      showingReplies = false;
    } else {
      showingReplies = true;
    }
    notifyListeners();
  }

  delete(GoForumPostComment comment) async {
    print("chungus");
    _commentDataService!.deleteComment(comment.postID, comment.timePostedInMilliseconds.toString());
    _navigationService!.back();
    navigateToPostView(comment.postID);
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

  navigateToPostView(String? id) {
    _navigationService!.navigateTo(Routes.ForumPostViewRoute(id: id));
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
