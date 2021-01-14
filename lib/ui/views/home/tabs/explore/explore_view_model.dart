import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class ExploreViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//

  navigateToSearchView() {
    _navigationService.navigateWithTransition(SearchView(), transition: 'fade', opaque: true);
  }

  navigateToCreateCauseView() {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute);
  }
}
