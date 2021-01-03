import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class ProfileViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  CollectionReference causesRef = FirebaseFirestore.instance.collection("causes");

  ScrollController scrollController = ScrollController();

  List<DocumentSnapshot> causesResults = [];
  DocumentSnapshot lastCauseDocSnap;

  bool loadingAdditionalCauses = false;
  bool moreCausesAvailable = true;

  int resultsLimit = 20;

  GoUser user;

  initialize(TabController tabController, GoUser currentUser) async {
    user = currentUser;
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        if (tabController.index == 0) {
          loadAdditionalCauses();
        }
      }
    });
    notifyListeners();
    await loadData();
    setBusy(false);
  }

  loadData() async {
    await loadCauses();
  }

  Future<void> refreshPosts() async {
    causesResults = [];
    notifyListeners();
    await loadCauses();
  }

  loadCauses() async {}

  loadAdditionalCauses() async {}

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

  navigateToSettingsPage() {
    _navigationService.navigateTo(Routes.SettingsViewRoute, arguments: {'data': 'example'});
  }
}
