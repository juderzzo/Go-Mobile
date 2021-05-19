import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';

class ListUserPostsModel extends BaseViewModel {
  PostDataService _postDataService = locator<PostDataService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
  CustomNavigationService customNavigationService = locator<CustomNavigationService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-user-posts-created-key";

  ///USER DATA
  GoUser get user => _reactiveUserService.user;
  String? uid;

  ///DATA
  List<DocumentSnapshot> dataResults = [];

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 30;

  initialize(String? id) async {
    if (id != null) {
      uid = id;
    } else {
      uid = user.id;
    }
    notifyListeners();
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
    dataResults = await _postDataService.loadPostsByUser(
      uid: user.id,
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
    List<DocumentSnapshot> newResults = await _postDataService.loadAdditionalPostsByUser(
      uid: user.id,
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

  showContentOptions(dynamic content) async {
    String val = await customBottomSheetService.showContentOptions(content: content);
    if (val == "deleted content") {
      dataResults.removeWhere((doc) => doc.id == content.id);
      listKey = getRandomString(5);
      notifyListeners();
    }
  }
}
