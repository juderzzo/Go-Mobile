import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:stacked/stacked.dart';

class ListExploreUsersModel extends BaseViewModel {
  UserDataService _userDataService = locator<UserDataService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-explore-users-key";

  ///DATA
  List<DocumentSnapshot> dataResults = [];

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 30;

  initialize() async {
    await loadData();
  }

  Future<void> refreshData() async {
    scrollController.jumpTo(scrollController.position.minScrollExtent);

    //clear previous data
    dataResults = [];
    loadingAdditionalData = false;
    moreDataAvailable = true;

    notifyListeners();
    //load all data
    await loadData();
  }

  loadData() async {
    setBusy(true);

    //load data with params
    dataResults = await _userDataService.loadUsers(
      resultsLimit: resultsLimit,
    );

    notifyListeners();

    setBusy(false);
  }

  loadAdditionalData() async {
    //check if already loading data or no more data available
    if (loadingAdditionalData || !moreDataAvailable) {
      return;
    }

    //set loading additional data status
    loadingAdditionalData = true;
    notifyListeners();

    //load additional data
    List<DocumentSnapshot> newResults = await _userDataService.loadAdditionalUsers(
      lastDocSnap: dataResults[dataResults.length - 1],
      resultsLimit: resultsLimit,
    );

    //notify if no more data available
    if (newResults.length == 0) {
      moreDataAvailable = false;
    } else {
      dataResults.addAll(newResults);
    }

    //set loading additional data status
    loadingAdditionalData = false;
    notifyListeners();
  }
}
