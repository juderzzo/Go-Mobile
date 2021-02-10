import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class ProfileViewModel extends BaseViewModel {
  ///SERVICES
  NavigationService _navigationService = locator<NavigationService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///CURRENT USER
  GoUser user;

  ///DATA RESULTS
  List<DocumentSnapshot> causesFollowingResults = [];
  bool loadingAdditionalCausesFollowing = false;
  bool moreCausesFollowingAvailable = true;

  List<DocumentSnapshot> causesCreatedResults = [];
  bool loadingAdditionalCausesCreated = false;
  bool moreCausesCreatedAvailable = true;

  int resultsLimit = 15;

  initialize(TabController tabController, GoUser currentUser) async {
    user = currentUser;
    //notifyListeners();
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
    //notifyListeners();
    await loadData();
    setBusy(false);
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

  ///SHOW OPTIONS
  showOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.currentUserOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        navigateToEditProfilePage();
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

  static checkIfPostExists(id) async {
    PostDataService _postDataService = locator<PostDataService>();
    return await _postDataService.getPostByID(id);
  }

  static generatePost(index, uid) async {
    PostDataService _postDataService = locator<PostDataService>();
    UserDataService _userDataService = locator<UserDataService>();
    //generate the liked list and remove a reference if it doesnt exist
    GoUser user = await _userDataService.getGoUserByID(uid);
    String id = user.liked[index];
    bool likedPostDeleted = false;
    if (await _postDataService.checkIfPostExists(id)) {
      GoForumPost val = await _postDataService.getPostByID(id);
      print(val.runtimeType);
      return val;
    }
  }

  static updateLiked(String uid, List liked) {
    UserDataService _userDataService = locator<UserDataService>();
    _userDataService.updateLikedPosts(uid, liked);
  }

  navigateToEditProfilePage() {
    _navigationService.navigateTo(Routes.EditProfileViewRoute, arguments: {
      'id': user.id,
    });
  }

  navigateToSettingsPage() {
    _navigationService
        .navigateTo(Routes.SettingsViewRoute, arguments: {'data': 'example'});
  }
}
