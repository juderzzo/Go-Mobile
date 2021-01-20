import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class HomeViewModel extends BaseViewModel {
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

  ///NAVIGATION
  navigateToNotificationsView() {
    _navigationService.navigateTo(Routes.NotificationsViewRoute);
  }

  navigateToCreateCauseView() {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute);
  }
}
