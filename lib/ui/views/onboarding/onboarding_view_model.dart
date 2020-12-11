import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///NAVIGATION
  replaceWithHomeNavView() {
    _navigationService.replaceWith(Routes.HomeNavViewRoute);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}