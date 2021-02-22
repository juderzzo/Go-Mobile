import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
import 'package:go/services/firestore/notification_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
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
  NotificationDataService _notificationDataService = locator<NotificationDataService>();

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
  bool isAdmin = false;
  bool isReplying = false;
  bool refreshingComments = true;
  GoForumPostComment commentToReplyTo;
  bool likedPost = false;

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

    isAdmin = (uid == post.causeID);
    print(isAdmin);

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

  delete() async {
    _postDataService.deletePost(post.id);
    notifyListeners();
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
    print("res");
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isAuthor || isAdmin ? BottomSheetType.postAuthorOptions : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;

      if (res == "edit") {
        //edit
        print("edit");
      } else if (res == "share") {
        //share
        print("edit");
      } else if (res == "report") {
        //report
        print("edit");
      } else if (res == "delete") {
        delete();
      }
      notifyListeners();
    }
  }

  ///COMMENTING

  toggleReply(FocusNode focusNode, GoForumPostComment comment) {
    isReplying = true;
    commentToReplyTo = comment;
    focusNode.requestFocus();
  }

  submitComment({BuildContext context, String commentVal}) async {
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
      await _commentDataService.sendComment(post.id, post.authorID, comment);
      sendCommentNotification(text);
      sendUserMentionNotification(text);
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
    sendCommentReplyNotification(commentToReplyTo.senderUID, text);
    sendUserMentionNotification(text);
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

  likeUnlikePost(String postID) async {
    String currentUID = await _authService.getCurrentUserID();
    _userDataService.likeUnlikePost(currentUID, postID);
    likedPost = !likedPost;
    print(likedPost);
    notifyListeners();
  }

  ///NOTIFICATIONS
  sendCommentNotification(String comment) {
    GoNotification notification = GoNotification().generateGoCommentNotification(
      postID: post.id,
      receiverUID: post.authorID,
      senderUID: currentUser.id,
      commenterUsername: "@${currentUser.username}",
      comment: comment,
    );
    _notificationDataService.sendNotification(notif: notification);
  }

  sendCommentReplyNotification(String receiverUID, String comment) {
    GoNotification notification = GoNotification().generateCommmentReplyNotification(
      postID: post.id,
      receiverUID: receiverUID,
      senderUID: currentUser.id,
      commenterUsername: "@${currentUser.username}",
      comment: comment,
    );
    _notificationDataService.sendNotification(notif: notification);
  }

  sendUserMentionNotification(String comment) async {
    List<String> mentionedUsernames = getListOfUsernamesFromString(comment);
    print(mentionedUsernames);
    mentionedUsernames.forEach((username) async {
      GoUser user = await _userDataService.getGoUserByUsername(username);
      if (user != null) {
        GoNotification notification = GoNotification().generateGoCommentMentionNotification(
          postID: post.id,
          receiverUID: user.id,
          senderUID: currentUser.id,
          commenterUsername: "@${currentUser.username}",
          comment: comment,
        );
        print(notification.toMap());
        _notificationDataService.sendNotification(notif: notification);
      }
    });
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
