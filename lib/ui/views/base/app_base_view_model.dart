import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/enums/init_error_status.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_messaging_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/utils/network_status.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppBaseViewModel extends StreamViewModel<GoUser> with ReactiveServiceMixin {
  ///SERVICES
  AuthService _authService = locator<AuthService>();
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  FirebaseMessagingService _firebaseMessagingService = locator<FirebaseMessagingService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  ///INITIAL DATA
  InitErrorStatus initErrorStatus = InitErrorStatus.network;

  ///CURRENT USER
  bool get isLoggedIn => _reactiveUserService.userLoggedIn;
  GoUser get user => _reactiveUserService.user;

  ///TAB BAR STATE
  int _navBarIndex = 0;
  int get navBarIndex => _navBarIndex;

  //notifs
  bool configuredFirebaseMessaging = false;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }

  bool initialized = false;

  initialize() async {
    setBusy(true);
    bool connectedToNetwork = await isConnectedToNetwork();
    if (!connectedToNetwork) {
      initErrorStatus = InitErrorStatus.network;
      notifyListeners();
      setBusy(false);
      _snackbarService!.showSnackbar(
        title: 'Network Error',
        message: "There Was an Issue Connecting to the Internet",
        duration: Duration(seconds: 5),
      );
    } else {
      initErrorStatus = InitErrorStatus.none;
      await _dynamicLinkService.handleDynamicLinks();
      // _firebaseMessagingService.configFirebaseMessaging();
      // _firebaseMessagingService.updateFirebaseMessageToken(user.id);
      notifyListeners();
    }
    initialized = true;
  }

  Future<bool> isConnectedToNetwork() async {
    bool isConnected = await NetworkStatus().isConnected();
    return isConnected;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  @override
  void onData(GoUser? data) {
    if (data != null) {
      if (!data.isValid()) {
        _reactiveUserService.updateUserLoggedIn(false);
        _reactiveUserService.updateUser(data);
        notifyListeners();
        setBusy(false);
      } else if (user != data) {
        _reactiveUserService.updateUser(data);
        _reactiveUserService.updateUserLoggedIn(true);
        notifyListeners();
        setBusy(false);
      }
    }
  }

  @override
  Stream<GoUser> get stream => streamUser();

  Stream<GoUser> streamUser() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      GoUser? userData = GoUser();
      if (!isLoggedIn) {
        yield userData;
      } else {
        String? uid = await _authService.getCurrentUserID();
        userData = await _userDataService.getGoUserByID(uid);
        yield userData;
      }
    }
  }
}
