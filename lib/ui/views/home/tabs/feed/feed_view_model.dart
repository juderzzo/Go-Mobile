import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:stacked/stacked.dart';

class FeedViewModel extends BaseViewModel {
  CauseDataService? _causeDataService = locator<CauseDataService>();
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();
  PostDataService? _postDataService = locator<PostDataService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();

  ///CURRENT USER
  GoUser get user => _reactiveUserService.user;

  ///DATA RESULTS
  List<DocumentSnapshot> causesFollowingResults = [];
  bool loadingAdditionalCausesFollowing = false;
  bool moreCausesFollowingAvailable = true;
  bool refreshingPosts = false;

  int resultsLimit = 15;

  List newPosts = [];
  List newActions = [];
  //for later
  List? recCauses;
  bool initialized = false;

  initialize() async {
    await loadPosts();
    notifyListeners();
    scrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalCausesFollowing();
      }
    });
    notifyListeners();
    //await loadCausesFollowing();
    //print(causesFollowingResults);
    //print(loadPosts());
    setBusy(false);
    initialized = true;
  }

  // Future<void> refreshPosts() async {
  //   refreshingPosts = true;
  //   postResults = [];
  //   notifyListeners();
  //   await loadPosts();
  // }

  Future<void> refreshCausesFollowing() async {
    refreshingPosts = true;
    causesFollowingResults = [];
    notifyListeners();
    await loadCausesFollowing();
  }

  loadCausesFollowing() async {
    //print(user);
    causesFollowingResults = await _causeDataService!.loadCausesFollowing(
      resultsLimit: resultsLimit,
      uid: user!.id!,
    );
    refreshingPosts = false;
    notifyListeners();
  }

  loadPostsCause(causeID) async {
    List posts = await _postDataService!.loadPosts(
      resultsLimit: resultsLimit,
      causeID: causeID,
    );
    refreshingPosts = false;
    //notifyListeners();
    return posts;
  }

  Future<void> loadPosts() async {
    newPosts = [];
    await loadCausesFollowing().then((b) {
      //print(b);
      causesFollowingResults.forEach((element) async {
        // print(element.get('id'));
        List causePosts = await loadPostsCause(element.get('id'));
        // print(causePosts);
        newPosts.addAll(causePosts);
        notifyListeners();
      });
    });
  }

  loadAdditionalCausesFollowing() async {
    if (loadingAdditionalCausesFollowing || !moreCausesFollowingAvailable) {
      return;
    }
    loadingAdditionalCausesFollowing = true;
    notifyListeners();
    List<QueryDocumentSnapshot> newResults = await (_causeDataService!.loadAdditionalCausesFollowing(
      lastDocSnap: causesFollowingResults[causesFollowingResults.length - 1],
      resultsLimit: resultsLimit,
      uid: user!.id,
    ) as FutureOr<List<QueryDocumentSnapshot>>);
    if (newResults.length == 0) {
      moreCausesFollowingAvailable = false;
    } else {
      causesFollowingResults.addAll(newResults);
    }
    loadingAdditionalCausesFollowing = false;
    notifyListeners();
  }
}
