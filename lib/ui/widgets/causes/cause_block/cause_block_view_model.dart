import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  String creatorUsername;
  String creatorProfilePicURL;
  bool isCreator = false;
  bool isLoading = true;
  List images = [];

  initialize(String creatorID, List imageURLs) async {
    String currentUID = await _authService.getCurrentUserID();
    GoUser creator = await _userDataService.getGoUserByID(creatorID);
    if (currentUID == creatorID) {
      isCreator = true;
    }
    creatorUsername = "@" + creator.username;
    creatorProfilePicURL = creator.profilePicURL;
    imageURLs.forEach((url) {
      images.add(
        NetworkImage(url),
      );
    });
    isLoading = false;
    notifyListeners();
  }

  showOptions(BuildContext context, id) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isCreator
          ? BottomSheetType.causeCreatorOptions
          : BottomSheetType.causeOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      print(res);
      if (res == "edit") {
        //edit
      } else if (res == "share") {
        //share
      } else if (res == "report") {
        //report
        if (isCreator) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                    content:
                        Text("Are you sure you want to delete this cause?"),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "No",
                          )),
                      FlatButton(
                          onPressed: () {
                            _causeDataService.deleteCause(id);
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Yes",
                          )),
                    ],
                  ));
        }
      } else if (res == "delete") {
        //delete
      }
      notifyListeners();
    }
  }

  ///NAVIGATION
  navigateToCauseView(String id) {
    _navigationService.navigateTo(Routes.CauseViewRoute, arguments: {'id': id});
  }

  navigateToUserView(String uid) {
    _navigationService
        .navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }
}
