import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomNavigationService {
  NavigationService _navigationService = locator<NavigationService>();

  navigateToCauseView(String id) {
    _navigationService.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToCreateCauseView(String id) {
    //_navigationService.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToForumPostView(String id) {
    //_navigationService.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToCreateForumPostView(String id) {
    //_navigationService.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToSearchView() {
    _navigationService.navigateWithTransition(SearchView(), transition: 'fade', opaque: true);
  }
}
