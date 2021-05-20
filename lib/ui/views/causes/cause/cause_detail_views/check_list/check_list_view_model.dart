import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckListViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  NavigationService? _navigationService = locator<NavigationService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  UserDataService? _userService = locator<UserDataService>();

  late var adInstance; //RewardedVideoAd.instance;

  bool? monetizer = false;
  bool bus = false;
  bool? working;
  bool canWatchVideo = true;
  String? link = "";
  bool? isCreator = false;

  initialize(id) async {
    working = false;
    String? uid = await _authService!.getCurrentUserID();
    //print(busy("f"));
    GoCause cause = await _causeDataService!.getCauseByID(id);
    link = cause.charityURL;
    isCreator = (cause.creatorID == uid);
    print(isCreator);

    monetizer = await monetized(id);

    //GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[kGADSimulatorID];
    setBusy(true);
    // notifyListeners();
    // adInstance
    //     .load(
    //   adUnitId: 'ca-app-pub-9312496461922231/3137448396',
    // )
    //     .then((value) {
    //   //print("new ad loaded");
    //   setBusy(false);
    //   //print("monetizer");
    //   //print(monetizer);
    // });

    // RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event,
    //     {String rewardType, int rewardAmount}) async {
    //   if (event == RewardedVideoAdEvent.rewarded) {
    //     {
    //       //print("rewarded");
    //       // Here, apps should update state to reflect the reward.
    //       String uid = await _authService.getCurrentUserID().then((value) {
    //         _userService.updateGoUserPoints(value, 2);
    //         resetVideo();
    //       });
    //
    //       _causeDataService.addView(id);
    //       adInstance.load(
    //         adUnitId: 'ca-app-pub-9312496461922231/3137448396',
    //       );
    //     }
    //     ;
    //   }
    // };
  }

  Future resetVideo() async {
    canWatchVideo = false;
    Future.delayed(Duration(minutes: 2)).then((value) {
      canWatchVideo = true;
    });
  }

  Future<bool?> monetized(id) async {
    GoCause cause = await _causeDataService!.getCauseByID(id);
    return cause.monetized;
  }

  Future<String?> userID() async {
    return await _authService!.getCurrentUserID();
  }

  Future<bool> addCheck(id, uid) async {
    print(id);
    return await _userService!.updateCheckedItems(id, uid);
  }

  static Future<bool> isChecked(id, uid) async {
    UserDataService _userService = locator<UserDataService>();
    return await _userService.isChecked(id, uid);
  }

  static Future<List> generateItem(id, uid) async {
    CauseDataService? _causeDataService = locator<CauseDataService>();
    List strings = []; //await _causeDataService.getItem(id);
    if (await isChecked(id, uid)) {
      strings.add('true');
    } else {
      strings.add('false');
    }
    return strings;
  }

  busyButton(bool g) {
    bus = g;
  }

  playAd(causeID) async {
    busyButton(true);
    print("trying");

    notifyListeners();

    adInstance
        .load(
      adUnitId: 'ca-app-pub-9312496461922231/3137448396',
    )
        .then(
      (value) {
        print("new ad loaded");

        adInstance.show().then((value) {
          print(value);
          print("horray");

          busyButton(false);
          notifyListeners();
        }, onError: (object) {
          playAd(causeID);
        });
      },
    );
  }

  navigateToEdit(String? id) {
    _navigationService!.navigateTo(Routes.EditCheckListViewRoute(id: id));
    // _navigationService.navigateTo(Routes.EditChecklistView,
    //     arguments: EditChecklistViewArguments(arguments: [actions, creatorID, currentUID, name, causeID, headers, subheaders]));
  }
}
