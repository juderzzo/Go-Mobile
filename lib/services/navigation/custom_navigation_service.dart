import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomNavigationService {
  NavigationService _navigationService = locator<NavigationService>();

  navigateToUserView(String id) {
    _navigationService.navigateTo(Routes.UserProfileViewRoute(id: id));
  }

  navigateToCauseView(String id) {
    _navigationService.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToCreateCauseView(String id) {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute(id: id));
  }

  navigateToCreateActionItems(String id) {
    _navigationService.navigateTo(Routes.EditCheckListViewRoute(id: id));
  }

  navigateToForumPostView(String id) {
    _navigationService.navigateTo(Routes.ForumPostViewRoute(id: id));
  }

  

  navigateToCreateForumPostView(String causeID, String id) {
    _navigationService.navigateTo(Routes.CreateForumPostViewRoute(causeID: causeID, id: id));
  }

  navigateToSearchView() {
    _navigationService.navigateWithTransition(SearchView(), transition: 'fade', opaque: true);
  }

  navigateToSettingsView() {
    _navigationService.navigateTo(Routes.SettingsViewRoute);
  }
}
