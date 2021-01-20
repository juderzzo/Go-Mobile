import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseViewModel extends StreamViewModel<GoCause> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  ScrollController postsScrollController = ScrollController();

  ///DATA
  String currentUID;
  GoUser user;
  String causeID;
  GoCause cause;
  GoUser causeCreator;
  List images = [];
  bool isFollowingCause;
  bool loadedImages = false;
  bool refreshingPosts = false;

  ///DATA RESULTS
  List<DocumentSnapshot> postResults = [];
  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;

  int resultsLimit = 15;

  initialize(BuildContext context) async {
    setBusy(true);
    currentUID = await _authService.getCurrentUserID();
    notifyListeners();
    Map<String, dynamic> args = RouteData.of(context).arguments;
    causeID = args['id'];

    ///SET SCROLL CONTROLLER
    postsScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * postsScrollController.position.maxScrollExtent;
      if (postsScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalPosts();
      }
    });
    notifyListeners();
  }

  getCauseCreator(String id) async {
    var res = await _userDataService.getGoUserByID(id);
    if (res is String) {
      _dialogService.showDialog(
        title: "Cause Creator Error",
        description: "There was an issue loading the details of the creator of this cause",
        barrierDismissible: true,
      );
    } else {
      causeCreator = res;
    }
    notifyListeners();
  }

  followUnfollowCause() {
    _causeDataService.followUnfollowCause(causeID, currentUID);
  }

  ///LOAD POSTS
  Future<void> refreshPosts() async {
    refreshingPosts = true;
    postResults = [];
    notifyListeners();
    await loadPosts();
  }

  loadPosts() async {
    postResults = await _postDataService.loadPosts(
      resultsLimit: resultsLimit,
      causeID: cause.id,
    );
    refreshingPosts = false;
    notifyListeners();
  }

  loadAdditionalPosts() async {
    if (loadingAdditionalPosts || !morePostsAvailable) {
      return;
    }
    loadingAdditionalPosts = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _postDataService.loadAdditionalPosts(
      lastDocSnap: postResults[postResults.length - 1],
      resultsLimit: resultsLimit,
      causeID: cause.id,
    );
    if (newResults.length == 0) {
      morePostsAvailable = false;
    } else {
      postResults.addAll(newResults);
    }
    loadingAdditionalPosts = false;
    notifyListeners();
  }

  ///STREAM CAUSE DATA
  @override
  void onData(GoCause data) {
    if (data != null) {
      cause = data;
      if (cause.followers.contains(currentUID)) {
        isFollowingCause = true;
      } else {
        isFollowingCause = false;
      }
      if (!loadedImages) {
        cause.imageURLs.forEach((url) {
          images.add(
            NetworkImage(url),
          );
        });
        loadedImages = true;
      }
      getCauseCreator(cause.creatorID);
      loadPosts();
      notifyListeners();
      setBusy(false);
    }
  }

  @override
  Stream<GoCause> get stream => streamCause();

  Stream<GoCause> streamCause() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      var res = await _causeDataService.getCauseByID(causeID);
      if (res is String) {
        yield null;
      } else {
        yield res;
      }
    }
  }

  ///NAVIGATION
  navigateToCreatePostView() async {
    String data = await _navigationService.navigateTo(Routes.CreateForumPostViewRoute, arguments: {'causeID': cause.id});
    if (data == 'newPostCreated') {
      refreshPosts();
    }
  }

  popPage() {
    _navigationService.popRepeated(1);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
