import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_messaging_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RootViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  UserDataService _userDataService = locator<UserDataService>();
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseMessagingService _firebaseMessagingService = locator<FirebaseMessagingService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  ///CHECKS IF USER IS LOGGED IN
  Future checkAuthState() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      ///CHECK IF USER EXISTS
      String? uid = await _authService.getCurrentUserID();
      bool? userExists = await _userDataService.checkIfUserExists(id: uid!);

      if (userExists == null) {
        return;
      } else if (userExists) {
        GoUser user = await _userDataService.getGoUserByID(uid);
        _reactiveUserService.updateUser(user);
        _reactiveUserService.updateUserLoggedIn(true);

        ///CHECK IF USER ONBOARDED
        if (user.onboarded == null || !user.onboarded!) {
          //onboard user
        } else {
          _navigationService.replaceWith(Routes.AppBaseViewRoute);
        }
      } else {
        ///CREATE NEW USER
        GoUser user = GoUser().generateNewUser(id: uid);
        bool createdUser = await _userDataService.createGoUser(user: user);
        if (createdUser) {
          _reactiveUserService.updateUser(user);
          _reactiveUserService.updateUserLoggedIn(true);
        } else {
          return;
        }
      }
    } else {
      _navigationService.replaceWith(Routes.SignInViewRoute);
    }
  }
}
