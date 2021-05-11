import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AdminViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  //index = 0
  bool showMoney = false;

  //index = 1
  bool showAdmins = false;

  //index = 2
  bool showFollowers = false;

  List<SearchResult> currentAdmins = [];

  initialize(GoCause cause) async {
    currentAdmins = [];

    //print("init");
    cause.admins!.forEach((element) async {
      print(element);
      GoUser user = await _userDataService!.getGoUserByID(element);
      SearchResult result = SearchResult(additionalData: user.profilePicURL, id: user.id, type: null, name: user.username);

      currentAdmins.add(result);
    });
  }

  updateAdmins(GoCause cause) async {
    GoCause c = await _causeDataService!.getCauseByID(cause.id);
    if (c.admins != cause.admins) {
      currentAdmins = [];
      c.admins!.forEach((element) async {
        print(element);
        GoUser user = await _userDataService!.getGoUserByID(element);
        SearchResult result = SearchResult(additionalData: user.profilePicURL, id: user.id, type: null, name: user.username);

        currentAdmins.add(result);
      });
    }
  }

  showAdminDialog() {
    _dialogService!
        .showCustomDialog(title: "Max number of administrators", description: "You are only allowed 3 administrators in addition to yourself per cause");
  }

  showTake(int? index, model) {
    //print(index);
    if (index == 0) {
      showMoney = !showMoney;
      //print(showMoney);
    }
    if (index == 1) {
      showAdmins = !showAdmins;
    }
    if (index == 2) {
      showFollowers = !showFollowers;
    }
    model.notifyListeners();
  }

  navigateToUserView(String id) {
    _navigationService!.navigateTo(Routes.UserProfileViewRoute(id: id));
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
