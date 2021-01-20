import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
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
  CommentDataService _commentDataService = locator<CommentDataService>();

  ///HELPERS
  ScrollController commentScrollController = ScrollController();
  TextEditingController commentTextController = TextEditingController();

  ///DATA RESULTS
  bool loadingAdditionalComments = false;
  bool moreCommentsAvailable = true;
  List<DocumentSnapshot> commentResults = [];
  int resultsLimit = 15;

  ///DATA
  GoUser currentUser;
  GoUser author;
  GoForumPost post;
  bool isAuthor = false;
  bool isReplying = false;
  bool refreshingComments = true;
  GoForumPostComment commentToReplyTo;

  ///

  initialize(BuildContext context) async {
    setBusy(true);
    String uid = await _authService.getCurrentUserID();
    currentUser = await _userDataService.getGoUserByID(uid);

    Map<String, dynamic> args = RouteData.of(context).arguments;
    String postID = args['postID'] ?? "";

    var res = await _postDataService.getPostByID(postID);
    if (res is String) {
    } else {
      post = res;
    }
    author = await _userDataService.getGoUserByID(post.authorID);
    if (currentUser.id == post.authorID) {
      isAuthor = true;
    }

    ///SET SCROLL CONTROLLER
    commentScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * commentScrollController.position.maxScrollExtent;
      if (commentScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalComments();
      }
    });
    await loadComments();
    notifyListeners();
    setBusy(false);
  }

  ///LOAD POSTS
  Future<void> refreshComments() async {
    refreshingComments = true;
    commentResults = [];
    notifyListeners();
    await loadComments();
  }

  loadComments() async {
    commentResults = await _commentDataService.loadComments(postID: post.id, resultsLimit: resultsLimit);
    refreshingComments = false;
    notifyListeners();
    print(commentResults.length);
  }

  loadAdditionalComments() async {
    if (loadingAdditionalComments || !moreCommentsAvailable) {
      return;
    }
    loadingAdditionalComments = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _commentDataService.loadAdditionalComments(
      lastDocSnap: commentResults[commentResults.length - 1],
      resultsLimit: resultsLimit,
      postID: post.id,
    );
    if (newResults.length == 0) {
      moreCommentsAvailable = false;
    } else {
      commentResults.addAll(newResults);
    }
    loadingAdditionalComments = false;
    notifyListeners();
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

  toggleReply(FocusNode focusNode, GoForumPostComment comment) {
    isReplying = true;
    commentToReplyTo = comment;
    focusNode.requestFocus();
  }

  submitComment({BuildContext context, String commentVal}) {
    isReplying = false;
    String text = commentVal.trim();
    if (text.isNotEmpty) {
      GoForumPostComment comment = GoForumPostComment(
        postID: post.id,
        senderUID: currentUser.id,
        username: currentUser.username,
        message: text,
        isReply: false,
        replies: [],
        replyCount: 0,
        timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      );
      CommentDataService().sendComment(post.id, post.authorID, comment);
      clearState(context);
    }
    refreshComments();
  }

  deleteComment({BuildContext context, String commentID}) async {
    isReplying = false;
    await CommentDataService().deleteComment(post.id, commentID);
    clearState(context);
    refreshComments();
  }

  replyToComment({BuildContext context, String commentVal}) async {
    String text = commentVal.trim();
    if (text.isNotEmpty) {
      GoForumPostComment comment = GoForumPostComment(
        postID: post.id,
        senderUID: currentUser.id,
        username: currentUser.username,
        message: text,
        isReply: true,
        replies: [],
        replyCount: 0,
        replyReceiverUsername: commentToReplyTo.username,
        originalReplyCommentID: commentToReplyTo.timePostedInMilliseconds.toString(),
        timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      );
      await _commentDataService.replyToComment(
        post.id,
        commentToReplyTo.senderUID,
        commentToReplyTo.timePostedInMilliseconds.toString(),
        comment,
      );
    }
    clearState(context);
    refreshComments();
  }

  clearState(BuildContext context) {
    isReplying = false;
    commentToReplyTo = null;
    commentTextController.clear();
    FocusScope.of(context).unfocus();
    notifyListeners();
  }

  ///NAVIGATION
  navigateToUserView(String uid) {
    _navigationService.navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
