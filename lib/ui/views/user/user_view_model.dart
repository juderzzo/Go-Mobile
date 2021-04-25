import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserViewModel extends BaseViewModel {
  ///SERVICES
  NavigationService? _navigationService = locator<NavigationService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  UserDataService? _userDataService = locator<UserDataService>();
  PostDataService? _postDataService = locator<PostDataService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///CURRENT USER
  GoUser? user;

  ///DATA RESULTS
  List<DocumentSnapshot> causesFollowingResults = [];
  List<Widget> posts = [];
  bool loadingAdditionalCausesFollowing = false;
  bool moreCausesFollowingAvailable = true;
  bool? isFollowing = false;

  List<DocumentSnapshot> causesCreatedResults = [];
  bool loadingAdditionalCausesCreated = false;
  bool moreCausesCreatedAvailable = true;
  int postCounter = 0;

  int resultsLimit = 15;

  initialize(TabController? tabController, BuildContext context) async {
    //print("1");
    setBusy(true);
    Map<String, dynamic> args = {}; //RouteData.of(context).arguments;
    String? uid = args['uid'];
    user = await (_userDataService!.getGoUserByID(uid) as FutureOr<GoUser?>);
    isFollowing = await _userDataService!.isFollowing(uid);
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (tabController!.index == 1) {
          loadAdditionalCausesFollowing();
        } else if (tabController.index == 2) {
          loadAdditionalCausesCreated();
        }
      }
    });
    notifyListeners();
    posts = [];
    await loadData();
    loadPostsInitial();

    setBusy(false);
  }

  followUnfollowUser() {
    _userDataService!.followUnfollowUser(user!.id);
    notifyListeners();
  }

  ///LOAD ALL DATA
  loadData() async {
    await loadCausesFollowing();
    await loadCausesCreated();
  }

  ///REFRESH CAUSES FOLLOWING
  Future<void> refreshCausesFollowing() async {
    causesFollowingResults = [];
    notifyListeners();
    await loadCausesFollowing();
  }

  ///REFRESH CAUSES CREATED
  Future<void> refreshCausesCreated() async {
    causesCreatedResults = [];
    notifyListeners();
    await loadCausesCreated();
  }

  ///LOAD CAUSES FOLLOWING
  loadCausesFollowing() async {
    causesFollowingResults = await _causeDataService!.loadCausesFollowing(
      resultsLimit: resultsLimit,
      uid: user!.id,
    );
    notifyListeners();
  }

  loadPostsInitial() async {
    List p = await _postDataService!.loadPostsByUser(user!.id);
    for (GoForumPost i in p as Iterable<GoForumPost>) {
      posts.add(new ForumPostBlockView(
        post: i,
        displayBottomBorder: true,
      ));
    }
    print(posts.toString());
  }

  loadPosts() {
    return posts;
  }

  ///LOAD CAUSES CREATED
  loadCausesCreated() async {
    causesCreatedResults = await _causeDataService!.loadCausesCreated(
      resultsLimit: resultsLimit,
      uid: user!.id,
    );
    notifyListeners();
  }

  ///LOAD ADDITIONAL CAUSES FOLLOWING
  loadAdditionalCausesFollowing() async {
    if (loadingAdditionalCausesFollowing || !moreCausesFollowingAvailable) {
      return;
    }
    loadingAdditionalCausesFollowing = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _causeDataService!.loadAdditionalCausesFollowing(
      lastDocSnap: causesFollowingResults[causesFollowingResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user!.id,
    );
    if (newResults.length == 0) {
      moreCausesFollowingAvailable = false;
    } else {
      causesFollowingResults.addAll(newResults);
    }
    loadingAdditionalCausesFollowing = false;
    notifyListeners();
  }

  ///LOAD ADDITIONAL CAUSES CREATED
  loadAdditionalCausesCreated() async {
    if (loadingAdditionalCausesCreated || !moreCausesCreatedAvailable) {
      return;
    }
    loadingAdditionalCausesCreated = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _causeDataService!.loadAdditionalCausesCreated(
      lastDocSnap: causesCreatedResults[causesCreatedResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user!.id,
    );
    if (newResults.length == 0) {
      moreCausesCreatedAvailable = false;
    } else {
      causesCreatedResults.addAll(newResults);
    }
    loadingAdditionalCausesCreated = false;
    notifyListeners();
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToEditProfilePage() {
    // _navigationService.navigateTo(Routes.EditProfileViewRoute, arguments: {
    //   'id': user.id,
    // });
  }

  navigateToPreviousPage() {
    _navigationService!.back();
  }
}
