import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FeedViewModel extends BaseViewModel{
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();




  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///CURRENT USER
  GoUser user;

  ///DATA RESULTS
  List<DocumentSnapshot> causesFollowingResults = [];
  bool loadingAdditionalCausesFollowing = false;
  bool moreCausesFollowingAvailable = true;
  bool isReloading = true;

  int resultsLimit = 15;

  initialize({GoUser currentUser}) async {
    user = currentUser;
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalCausesFollowing();
      }
    });
    notifyListeners();
    await loadCausesFollowing();
    setBusy(false);
  }

  Future<void> refreshCausesFollowing() async {
    isReloading = true;
    causesFollowingResults = [];
    notifyListeners();
    await loadCausesFollowing();
  }

  loadCausesFollowing() async {
    causesFollowingResults = await _causeDataService.loadCausesFollowing(
      resultsLimit: resultsLimit,
      uid: user.id,
    );
    isReloading = false;
    notifyListeners();
  }

  loadAdditionalCausesFollowing() async {
    if (loadingAdditionalCausesFollowing || !moreCausesFollowingAvailable) {
      return;
    }
    loadingAdditionalCausesFollowing = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _causeDataService.loadAdditionalCausesFollowing(
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

}