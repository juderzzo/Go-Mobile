import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();

  completeOnboarding() async {
    busy(true);
    String uid = await _authService.getCurrentUserID();
    var res = await _userDataService.generateDummyUserFromID(uid);
    busy(false);
    print(res);
    replaceWithHomeNavView();
  }

  ///NAVIGATION
  replaceWithHomeNavView() {
    _navigationService.replaceWith(Routes.HomeNavViewRoute);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
