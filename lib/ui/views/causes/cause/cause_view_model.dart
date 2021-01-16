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

class CauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  ScrollController postsScrollController = ScrollController();

  ///CURRENT USER
  GoUser user;
  GoCause cause;
  GoUser causeCreator;
  List images = [];

  ///DATA RESULTS
  List<DocumentSnapshot> postResults = [];
  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;

  int resultsLimit = 15;

  initialize(BuildContext context) async {
    setBusy(true);
    Map<String, dynamic> args = RouteData.of(context).arguments;
    String causeID = args['id'];

    ///SET SCROLL CONTROLLER
    postsScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * postsScrollController.position.maxScrollExtent;
      if (postsScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalPosts();
      }
    });

    ///GET CAUSE
    var res = await _causeDataService.getCauseByID(causeID);
    if (res is String) {
      _dialogService.showDialog(
        title: "Cause Error",
        description: res,
        barrierDismissible: true,
      );
    } else {
      cause = res;
      cause.imageURLs.forEach((url) {
        images.add(
          NetworkImage(url),
        );
      });
      await getCauseCreator(cause.creatorID);
    }
    notifyListeners();

    ///LOAD POSTS
    if (cause != null) {
      await loadPosts();
      notifyListeners();
    }
    setBusy(false);
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
  }

  Future<void> refreshPosts() async {
    postResults = [];
    notifyListeners();
    await loadPosts();
  }

  loadPosts() async {
    postResults = await _postDataService.loadPosts(
      resultsLimit: resultsLimit,
      causeID: cause.id,
    );
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

  ///NAVIGATION
  navigateToCreatePostView() async {
    Map<String, dynamic> data = await _navigationService.navigateTo(Routes.CreateForumPostViewRoute, arguments: {'causeID': cause.id});
    if (data['result'] == 'newPostCreated') {
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
