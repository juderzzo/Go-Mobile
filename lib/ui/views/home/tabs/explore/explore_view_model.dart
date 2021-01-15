import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class ExploreViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  UserDataService _userDataService = locator<UserDataService>();

  ///HELPERS
  ScrollController causeScrollController = ScrollController();
  ScrollController userScrollController = ScrollController();

  ///DATA RESULTS
  String searchTerm;
  List<DocumentSnapshot> causeResults = [];
  bool loadingAdditionalCauses = false;
  bool moreCausesAvailable = true;

  List<DocumentSnapshot> userResults = [];
  bool loadingAdditionalUsers = false;
  bool moreUsersAvailable = true;

  int resultsLimit = 15;

  initialize() async {
    notifyListeners();
    causeScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * causeScrollController.position.maxScrollExtent;
      if (causeScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalCauses();
      }
    });
    userScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * userScrollController.position.maxScrollExtent;
      if (userScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalUsers();
      }
    });
    notifyListeners();
    await loadCauses();
    await loadUsers();
    setBusy(false);
  }

  ///CAUSES
  Future<void> refreshCauses() async {
    causeResults = [];
    notifyListeners();
    await loadCauses();
  }

  loadCauses() async {
    causeResults = await _causeDataService.loadCauses(resultsLimit: resultsLimit);
    notifyListeners();
  }

  loadAdditionalCauses() async {
    if (loadingAdditionalCauses || !moreCausesAvailable) {
      return;
    }
    loadingAdditionalCauses = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _causeDataService.loadAdditionalCauses(
      resultsLimit: resultsLimit,
      lastDocSnap: causeResults[causeResults.length - 1],
    );
    if (newResults.length == 0) {
      moreCausesAvailable = false;
    } else {
      causeResults.addAll(newResults);
    }
    loadingAdditionalCauses = false;
    notifyListeners();
  }

  ///USERS
  Future<void> refreshUsers() async {
    userResults = [];
    notifyListeners();
    await loadUsers();
  }

  loadUsers() async {
    userResults = await _userDataService.loadUsers(resultsLimit: resultsLimit);
    notifyListeners();
  }

  loadAdditionalUsers() async {
    if (loadingAdditionalUsers || !moreUsersAvailable) {
      return;
    }
    loadingAdditionalUsers = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _userDataService.loadAdditionalUsers(
      resultsLimit: resultsLimit,
      lastDocSnap: userResults[userResults.length - 1],
    );
    if (newResults.length == 0) {
      moreUsersAvailable = false;
    } else {
      userResults.addAll(newResults);
    }
    loadingAdditionalUsers = false;
    notifyListeners();
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//

  navigateToSearchView() {
    _navigationService.navigateWithTransition(SearchView(), transition: 'fade', opaque: true);
  }

  navigateToCreateCauseView() {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute);
  }
}
