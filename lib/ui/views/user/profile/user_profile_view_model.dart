import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/notification_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserProfileViewModel extends StreamViewModel<GoUser> {
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  ///DATA
  GoUser get currentUser => _reactiveUserService.user;

  ///UI HELPERS
  ScrollController scrollController = ScrollController();

  ///USER DATA
  String? uid;
  GoUser? user;
  bool? isFollowingUser;
  bool? mutedUser;
  bool sendNotification = false;

  ///STREAM USER DATA
  @override
  void onData(GoUser? data) {
    if (data != null) {
      user = data;
      if (isFollowingUser == null) {
        if (user!.followers != null && user!.followers!.contains(currentUser.id)) {
          isFollowingUser = true;
        } else {
          isFollowingUser = false;
        }
      }
      notifyListeners();
      setBusy(false);
    }
  }

  @override
  Stream<GoUser> get stream => streamUser();

  Stream<GoUser> streamUser() async* {
    while (true) {
      if (uid != null) {
        await Future.delayed(Duration(seconds: 1));
        var res = await _userDataService.getGoUserByID(uid);
        if (res is String) {
        } else {
          yield res;
        }
      }
    }
  }

  ///INITIALIZE
  initialize({String? id}) async {
    setBusy(true);
    uid = id;
    notifyListeners();
  }

  ///FOLLOW UNFOLLOW USER
  followUnfollowUser() async {
    if (user!.id == currentUser.id) {
      _customDialogService.showErrorDialog(description: "You cannot follow yourself");
    } else if (isFollowingUser!) {
      isFollowingUser = false;
      notifyListeners();
      await _userDataService.unFollowUser(currentUser.id, user!.id);
    } else {
      isFollowingUser = true;
      notifyListeners();
      bool followedUser = await _userDataService.followUser(currentUser.id, user!.id);
      if (followedUser) {
        GoNotification notification = GoNotification().generateGoFollowUserNotification(
          uid: user!.id!,
          senderUID: currentUser.id!,
          followerUsername: "@${currentUser.username}",
        );
        _notificationDataService.sendNotification(notif: notification);
        notifyListeners();
      }
    }
  }

  viewWebsite() {
    UrlHandler().launchInWebViewOrVC(user!.personalSite!);
  }

  showUserOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.userOptions,
      customData: {'muted': mutedUser},
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "share profile") {
        //share profile
        String? url = await _dynamicLinkService.createProfileLink(user: user!);
        _shareService.shareLink(url);
      } else if (res == "message") {
        //message user
      } else if (res == "block") {
        //block user
      } else if (res == "report") {
        //report user
      }
      notifyListeners();
    }
  }
}
