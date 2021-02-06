import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class UserViewModel extends BaseViewModel {
  ///SERVICES
  NavigationService _navigationService = locator<NavigationService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///CURRENT USER
  GoUser user;

  ///DATA RESULTS
  List<DocumentSnapshot> causesFollowingResults = [];
  bool loadingAdditionalCausesFollowing = false;
  bool moreCausesFollowingAvailable = true;
  bool isFollowing = false;

  List<DocumentSnapshot> causesCreatedResults = [];
  bool loadingAdditionalCausesCreated = false;
  bool moreCausesCreatedAvailable = true;

  int resultsLimit = 15;

  initialize(TabController tabController, BuildContext context) async {
    setBusy(true);
    Map<String, dynamic> args = RouteData.of(context).arguments;
    String uid = args['uid'];
    user = await _userDataService.getGoUserByID(uid);
    isFollowing = await _userDataService.isFollowing(uid);
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize =
          0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (tabController.index == 1) {
          loadAdditionalCausesFollowing();
        } else if (tabController.index == 2) {
          loadAdditionalCausesCreated();
        }
      }
    });
    notifyListeners();
    await loadData();

    setBusy(false);
  }

  followUnfollowUser() {
    _userDataService.followUnfollowUser(user.id);
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
    causesFollowingResults = await _causeDataService.loadCausesFollowing(
      resultsLimit: resultsLimit,
      uid: user.id,
    );
    notifyListeners();
  }

  ///LOAD CAUSES CREATED
  loadCausesCreated() async {
    causesCreatedResults = await _causeDataService.loadCausesCreated(
      resultsLimit: resultsLimit,
      uid: user.id,
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
    List<DocumentSnapshot> newResults =
        await _causeDataService.loadAdditionalCausesFollowing(
      lastDocSnap: causesFollowingResults[causesFollowingResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user.id,
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
    List<DocumentSnapshot> newResults =
        await _causeDataService.loadAdditionalCausesCreated(
      lastDocSnap: causesCreatedResults[causesCreatedResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user.id,
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
    _navigationService.navigateTo(Routes.EditProfileViewRoute, arguments: {
      'id': user.id,
    });
  }

  navigateToPreviousPage() {
    _navigationService.back();
  }
}
