import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  UserDataService _userDataService = locator<UserDataService>();

  GoCause cause;
  GoUser causeCreator;
  List images = [];
  Map<String, dynamic> args;

  initialize(BuildContext context) async {
    setBusy(true);
    args = RouteData.of(context).arguments;
    String causeID = args['id'];

    ///GET CAUSE
    var res = await _causeDataService.getCauseByID(causeID);
    if (res is String) {
      _dialogService.showDialog(
        title: "Cause Error",
        description: res,
        barrierDismissible: true,
      );
    } else {
      cause = res;
      cause.imageURLs.forEach((url) {
        images.add(
          NetworkImage(url),
        );
      });
      await getCauseCreator(cause.creatorID);
    }
    notifyListeners();
    setBusy(false);
  }

  getCauseCreator(String id) async {
    var res = await _userDataService.getGoUserByID(id);
    if (res is String) {
      _dialogService.showDialog(
        title: "Cause Creator Error",
        description: "There was an issue loading the details of the creator of this cause",
        barrierDismissible: true,
      );
    } else {
      causeCreator = res;
    }
  }

  ///NAVIGATION
  popPage() {
    _navigationService.popRepeated(1);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
