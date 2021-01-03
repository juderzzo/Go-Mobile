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
  List<DocumentSnapshot> causesResults = [];
  bool loadingAdditionalCauses = false;
  bool moreCausesAvailable = true;

  int resultsLimit = 15;

  initialize({GoUser currentUser}) async {
    user = currentUser;
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize =
          0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalCauses();
      }
    });
    notifyListeners();
    await loadData();
    setBusy(false);
  }

  loadData() async {
    await loadCauses();
  }

  Future<void> refreshData() async {
    setBusy(true);
    causesResults = [];
    await loadData();
    notifyListeners();
    setBusy(false);
  }

  Future<void> refreshCauses() async {
    causesResults = [];
    notifyListeners();
    await loadCauses();
  }

  loadCauses() async {
    causesResults = await _causeDataService.loadCausesFollowing(
      resultsLimit: resultsLimit,
      uid: user.id,
    );
    notifyListeners();
  }

  loadAdditionalCauses() async {
    if (loadingAdditionalCauses || !moreCausesAvailable) {
      return;
    }
    loadingAdditionalCauses = true;
    notifyListeners();
    List<DocumentSnapshot> newResults =
        await _causeDataService.loadAdditionalCauses(
      lastDocSnap: causesResults[causesResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user.id,
    );
    if (newResults.length == 0) {
      moreCausesAvailable = false;
    } else {
      causesResults.addAll(newResults);
    }
    loadingAdditionalCauses = false;
    notifyListeners();
  }

  openSearch() {}

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToCreateCauseView() {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute);
  }
}
