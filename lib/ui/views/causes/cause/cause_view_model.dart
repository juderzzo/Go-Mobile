import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseViewModel extends StreamViewModel<GoCause> {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();
  AuthService _authService = locator<AuthService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  CustomNavigationService _customNavigationService =
      locator<CustomNavigationService>();

  ///HELPERS
  ScrollController postsScrollController = ScrollController();

  ///DATA
  GoUser get user => _reactiveUserService.user;

  String? causeID;
  GoCause? cause;
  GoUser? causeCreator;
  GoUser? currentUser;
  List images = [];
  bool? isFollowingCause;
  bool loadedImages = false;
  bool refreshingPosts = false;
  bool isAdmin = false;

  ///DATA RESULTS
  List<GoCheckListItem>? checkListItems = [];
  List<DocumentSnapshot> postResults = [];
  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;
  int? tab = -1;

  int resultsLimit = 15;

  initialize(String id) async {
    setBusy(true);
    causeID = id;
    notifyListeners();
    String? currID = await _authService.getCurrentUserID();
    cause = await _causeDataService.getCauseByID(id);
    if (cause!.isValid()) {
      causeCreator = await _userDataService.getGoUserByID(cause!.creatorID);
      if (cause!.admins != null) {
        isAdmin = cause!.admins!.contains(user.id) || cause!.creatorID == currID;
      }
    }
    notifyListeners();
  }

  followUnfollowCause() {
    _causeDataService.followUnfollowCause(cause!.id!, user.id!);
  }

  ///CHECK LIST ITEMS
  loadCheckListItems() async {
    checkListItems = await _causeDataService.getCheckListItems(cause!.id);
    notifyListeners();
  }

  checkOffItem(GoCheckListItem item) async {
    List checkedOffBy = item.checkedOffBy!.toList(growable: true);
    if (!checkedOffBy.contains(user.id)) {
      DialogResponse? response = await _dialogService.showConfirmationDialog(
        title: "Are You Sure You've Completed this Task?",
        description: "Checking off this task is irreversible",
        cancelTitle: "Cancel",
        confirmationTitle: "Confirm",
        barrierDismissible: true,
      );
      if (response != null && response.confirmed) {
        //validate location if required
        if (item.lat != null && item.lon != null && item.address != null) {
          bool isNearbyLocation = await _locationService.isNearbyLocation(
              lat: item.lat!, lon: item.lon!);
          if (!isNearbyLocation) {
            _dialogService.showDialog(
              title: "Location Error",
              description:
                  "You are not near the required location to check off this item.",
              buttonTitle: "Ok",
            );
            return;
          }
        }
        //check off item
        checkedOffBy.add(user.id);

        await _causeDataService.checkOffCheckListItem(
            id: item.id, checkedOffBy: checkedOffBy);
        await _userDataService.updateGoUserPoints(user.id, item.points!);
      }
    }
  }

  ///STREAM CAUSE DATA
  @override
  void onData(GoCause? data) {
    if (data != null) {
      if (data.isValid()) {
        cause = data;
        if (cause!.followers!.contains(user.id)) {
          isFollowingCause = true;
        } else {
          isFollowingCause = false;
        }
        if (!loadedImages) {
          cause!.imageURLs!.forEach((url) {
            images.add(
              NetworkImage(url),
            );
          });
          loadedImages = true;
        }
        loadCheckListItems();
        notifyListeners();
        setBusy(false);
      }
    }
  }

  @override
  Stream<GoCause> get stream => streamCause();

  Stream<GoCause> streamCause() async* {
    while (true) {
      GoCause cause = GoCause();
      if (causeID == null) {
        yield cause;
      }
      await Future.delayed(Duration(seconds: 1));
      cause = await _causeDataService.getCauseByID(causeID);
      yield cause;
    }
  }

  ///NAVIGATION
  navigateToCreatePostView() async {
    _customNavigationService.navigateToCreateForumPostView(cause!.id!, "new");
  }

  navigateBack() {
    _navigationService.back();
  }
}
