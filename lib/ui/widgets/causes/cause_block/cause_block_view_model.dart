import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseBlockViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  DynamicLinkService? _dynamicLinkService = locator<DynamicLinkService>();
  ShareService? _shareService = locator<ShareService>();

  String? creatorUsername;
  String? creatorProfilePicURL;
  bool isCreator = false;
  bool isLoading = true;
  List images = [];
  String? videoLink;
  int orgLength = 0;
  int currentImageIndex = 0;

  initialize(String? creatorID, List imageURLs) async {
    String? currentUID = await _authService!.getCurrentUserID();
    GoUser creator = await (_userDataService!.getGoUserByID(creatorID) as FutureOr<GoUser>);

    if (currentUID == creatorID) {
      isCreator = true;
    }
    creatorUsername = "@" + creator.username!;
    creatorProfilePicURL = creator.profilePicURL;

    imageURLs.forEach((url) {
      images.add(
        NetworkImage(url),
      );
      orgLength++;
    });

    //print(orgLength);

    isLoading = false;
    notifyListeners();
  }

  showOptions(GoCause cause) async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      variant: isCreator ? BottomSheetType.causeCreatorOptions : BottomSheetType.causeOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      //print(cause.imageURLs);
      print(res);

      if (res == "Edit") {
        // if (isCreator) {
        //   print(cause.charityURL);
        //
        //   try {
        //     print("le");
        //     //   _navigationService.navigateTo(Routes.EditCauseViewRoute, arguments: {
        //     //   "causeID": cause.id,
        //     //   "name": cause.name,
        //     //   "goals": cause.goal,
        //     //   "why": cause.why,
        //     //   "who": cause.who,
        //     //   "resources": cause.resources,
        //     //   "charity": cause.charityURL,
        //     //   "videoLink": cause.videoLink,
        //     //   "img1": cause.imageURLs[0],
        //     //   "img2": cause.imageURLs.length > 1 ? cause.imageURLs[1] : null,
        //     //   "img3": cause.imageURLs.length > 2 ? cause.imageURLs[2] : null,
        //     //   "monetized": cause.monetized
        //
        //     // });
        //
        //     _navigationService.navigateTo(Routes.EditCauseViewRoute,
        //         arguments: EditCauseViewArguments(
        //             causeID: cause.id,
        //             name: cause.name,
        //             goals: cause.goal,
        //             why: cause.why,
        //             who: cause.who,
        //             resources: cause.resources,
        //             charity: cause.charityURL,
        //             videoLink: cause.videoLink,
        //             img1: NetworkImage(cause.imageURLs[0]),
        //             img2: cause.imageURLs.length > 1 ? NetworkImage(cause.imageURLs[1]) : null,
        //             img3: cause.imageURLs.length > 2 ? NetworkImage(cause.imageURLs[2]) : null,
        //             monetized: cause.monetized));
        //   } catch (e) {
        //     print(e);
        //   }
        // }
        // if (isCreator) {
        //   //print(cause.id);
        //   //redo the network images if theres a video
        //   List imgs = [];
        //   cause.imageURLs.forEach((url) {
        //     imgs.add(
        //       NetworkImage(url),
        //     );
        //     orgLength++;
        //   });
        //
        //   _navigationService.navigateTo(Routes.EditCauseViewRoute,
        //       arguments: EditCauseViewArguments(
        //           causeID: cause.id,
        //           name: cause.name,
        //           goals: cause.goal,
        //           who: cause.who,
        //           why: cause.why,
        //           charity: cause.charityURL,
        //           resources: cause.resources,
        //           img1: imgs[0],
        //           img2: imgs.length > 1 ? imgs[1] : null,
        //           img3: imgs.length > 2 ? imgs[2] : null,
        //           videoLink: cause.videoLink,
        //           monetized: cause.monetized
        //           ));
        // }
        //edit
      } else if (res == "share") {
        //share
        String url = await _dynamicLinkService!.createCauseLink(cause: cause!);
        _shareService!.shareLink(url);
      } else if (res == "report") {
        //report
        // if (isCreator) {
        //   showDialog(
        //       context: context,
        //       barrierDismissible: true,
        //       builder: (_) => AlertDialog(
        //             content: Text("Are you sure you want to delete this cause?"),
        //             actions: [
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.pop(context, true);
        //                   },
        //                   child: Text(
        //                     "No",
        //                   )),
        //               TextButton(
        //                   onPressed: () {
        //                     _causeDataService!.deleteCause(id);
        //                     Navigator.pop(context, true);
        //                   },
        //                   child: Text(
        //                     "Yes",
        //                   )),
        //             ],
        //           ));
        // }
      } else if (res == "delete") {
        //delete
      }
      notifyListeners();
    }
  }

  updateImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }

  ///NAVIGATION
  navigateToCauseView(String? id) {
    _navigationService!.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToUserView(String? id) {
    _navigationService!.navigateTo(Routes.CauseViewRoute(id: id));
  }
}
