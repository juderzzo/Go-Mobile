import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AdminViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  //index = 0
  bool showMoney = false;

  //index = 1
  bool showAdmins = false;

  //index = 2
  bool showFollowers = false;

  List<SearchResult> currentAdmins = [];
  

  initialize(GoCause cause) async {
    print("init");
    cause.admins.forEach((element) async {
      print(element);
      GoUser user = await _userDataService.getGoUserByID(element);
      SearchResult result = SearchResult(
        additionalData: user.profilePicURL,
        id: user.id,
        type: null,
        name: user.username
      );
      
      currentAdmins.add(result);
    });
      
    }
  
 

  showTake(int index, model){
    //print(index);
    if(index == 0){
      showMoney = !showMoney;
      //print(showMoney);
    }
    if(index == 1){
      showAdmins = !showAdmins;
    }
    if(index == 2){
      showFollowers = !showFollowers;
    }
    model.notifyListeners();
  }

  navigateToUserView(String uid) {
    _navigationService.navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
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