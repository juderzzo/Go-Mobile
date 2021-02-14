import 'package:firebase_admob/firebase_admob.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:go/ui/widgets/search/search_result_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckListViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  UserDataService _userService = locator<UserDataService>();
  RewardedVideoAd adInstance = RewardedVideoAd.instance;

  initialize() {
    //GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[kGADSimulatorID];
    setBusy(true);
    adInstance
        .load(
      adUnitId: 'ca-app-pub-9312496461922231/3137448396',
    )
        .then((value) {
      print(value);
      setBusy(false);
    });
  }

  Future<String> userID() async {
    return await _authService.getCurrentUserID();
  }

  Future<bool> addCheck(id, uid) async {
    print(id);
    return await _userService.updateCheckedItems(id, uid);
  }

  static Future<bool> isChecked(id, uid) async {
    UserDataService _userService = locator<UserDataService>();
    return await _userService.isChecked(id, uid);
  }

  static Future<List> generateItem(id, uid) async {
    CauseDataService _causeDataService = locator<CauseDataService>();
    List strings = await _causeDataService.getItem(id);
    if (await isChecked(id, uid)) {
      strings.add('true');
    } else {
      strings.add('false');
    }
    return strings;
  }

  navigateToEdit(
      actions, creatorID, currentUID, name, causeID, headers, subheaders) {
    _navigationService.navigateTo(Routes.EditChecklistView,
        arguments: EditChecklistViewArguments(arguments: [
          actions,
          creatorID,
          currentUID,
          name,
          causeID,
          headers,
          subheaders
        ]));
  }
}
