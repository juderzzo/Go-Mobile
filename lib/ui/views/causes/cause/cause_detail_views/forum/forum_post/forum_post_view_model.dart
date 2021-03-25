import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
import 'package:go/services/firestore/notification_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/utils/go_image_picker.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class ForumPostViewModel extends BaseViewModel {
  ThemeService _themeService = locator<ThemeService>();
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  CommentDataService _commentDataService = locator<CommentDataService>();
  NotificationDataService _notificationDataService =
      locator<NotificationDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  ///HELPERS
  ScrollController commentScrollController = ScrollController();
  TextEditingController commentTextController = TextEditingController();

  ///DATA RESULTS
  bool loadingAdditionalComments = false;
  bool moreCommentsAvailable = true;
  bool commentSending = false;

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

  //images
  bool imgChanged = false;
  dynamic imgFile;
  dynamic img;

  ///

  initialize(BuildContext context) async {
    setBusy(true);
    String uid = await _authService.getCurrentUserID();
    currentUser = await _userDataService.getGoUserByID(uid);
    GoCause cause;

    Map<String, dynamic> args = RouteData.of(context).arguments;
    String postID = args['postID'] ?? "";

    print(postID);
    var res = await _postDataService.getPostByID(postID);
    print(res);
    if (res is String) {
    } else {
      //post = res;
      //print(post);
      cause = await _causeDataService.getCauseByID(post.causeID);
    }
    author = await _userDataService.getGoUserByID(post.authorID);
    if (currentUser.id == post.authorID) {
      isAuthor = true;
    }

    ///SET SCROLL CONTROLLER
    commentScrollController.addListener(() {
      double triggerFetchMoreSize =
          0.9 * commentScrollController.position.maxScrollExtent;
      if (commentScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalComments();
      }
    });
    print(cause);

    isAdmin = (uid == post.causeID || cause.admins.contains(uid));
    //print(isAdmin);

    await loadComments();
    notifyListeners();
    setBusy(false);
  }

  bool isDarkMode() {
    return _themeService.isDarkMode ? true : false;
  }

  ///LOAD POSTS
  Future<void> refreshComments() async {
    refreshingComments = true;
    commentResults = [];
    notifyListeners();
    await loadComments();
  }

  loadComments() async {
    commentResults = await _commentDataService.loadComments(
        postID: post.id, resultsLimit: resultsLimit);
    refreshingComments = false;
    notifyListeners();
    if (commentResults.length != post.commentCount) ;
    post.commentCount = commentResults.length;
    _postDataService.updatePostby(post);
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
    List<DocumentSnapshot> newResults =
        await _commentDataService.loadAdditionalComments(
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
      variant: isAuthor || isAdmin
          ? BottomSheetType.postAuthorOptions
          : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;

      if (res == "edit") {
        //edit
        print("edit");
      } else if (res == "share") {
        //share post link
        String url = await _dynamicLinkService.createPostLink(
            postAuthorUsername: "${author.username}", post: post);
        _shareService.shareLink(url);
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

  submitComment(
      {BuildContext context, String commentVal, dynamic image}) async {
    isReplying = false;
    commentSending = true;
    String text = commentVal.trim();
    print("we got this far");
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
          image: image);
      await _commentDataService.sendComment(post.id, post.authorID, comment);
      sendCommentNotification(text);
      sendUserMentionNotification(text);
      clearState(context);
    }
    refreshComments();
    commentSending = false;
  }

  deleteComment({BuildContext context, String commentID}) async {
    isReplying = false;
    await CommentDataService().deleteComment(post.id, commentID);
    clearState(context);
    refreshComments();
  }

  replyToComment(
      {BuildContext context, String commentVal, dynamic image}) async {
    String text = commentVal.trim();
    commentSending = true;
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
          originalReplyCommentID:
              commentToReplyTo.timePostedInMilliseconds.toString(),
          timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
          image: image);
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
    commentSending = false;
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

  //comments with images

  void selectImage() async {
    imgChanged = true;
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
      img = imgFile;
      notifyListeners();
    }
  }

  ///NOTIFICATIONS
  sendCommentNotification(String comment) {
    GoNotification notification =
        GoNotification().generateGoCommentNotification(
      postID: post.id,
      receiverUID: post.authorID,
      senderUID: currentUser.id,
      commenterUsername: "@${currentUser.username}",
      comment: comment,
    );
    _notificationDataService.sendNotification(notif: notification);
  }

  sendCommentReplyNotification(String receiverUID, String comment) {
    GoNotification notification =
        GoNotification().generateCommmentReplyNotification(
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
        GoNotification notification =
            GoNotification().generateGoCommentMentionNotification(
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
    _navigationService
        .navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }

  navigateToPostView(String postID) {
    _navigationService
        .navigateTo(Routes.ForumPostViewRoute, arguments: {'postID': postID});
  }

// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
