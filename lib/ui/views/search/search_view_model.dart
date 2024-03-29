import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/services/algolia/algolia_search_service.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  AlgoliaSearchService? _algoliaSearchService = locator<AlgoliaSearchService>();
  UserDataService? _userDataService = locator<UserDataService>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();

  ///SEARCH
  List? recentSearchTerms = [];
  List<SearchResult> causeResults = [];
  List<SearchResult> userResults = [];

  int causesResultsLimit = 5;
  int userResultsLimit = 16;

  ///DATA
  String? uid;

  initialize() async {
    setBusy(true);
    uid = await _authService!.getCurrentUserID();
    recentSearchTerms = await _algoliaSearchService!.getRecentSearchTerms(uid: uid);
    notifyListeners();
    setBusy(false);
  }

  querySearchResults(String searchTerm) async {
    setBusy(true);
    if (searchTerm == null || searchTerm.trim().isEmpty) {
      await Future.delayed(Duration(seconds: 2));
      causeResults = [];
      userResults = [];
    } else {
      causeResults = await _algoliaSearchService!.searchCauses(searchTerm: searchTerm, resultsLimit: causesResultsLimit);
      userResults = await _algoliaSearchService!.searchUsers(searchTerm: searchTerm, resultsLimit: userResultsLimit);
    }
    notifyListeners();
    setBusy(false);
  }

  ///NAVIGATION
  viewAllResultsForSearchTerm({BuildContext? context, required String searchTerm}) async {
    if (searchTerm.trim().isNotEmpty) {
      searchTextController.text = searchTerm;
      notifyListeners();
      _algoliaSearchService!.storeSearchTerm(uid: uid, searchTerm: searchTerm);
      await _navigationService!.navigateWithTransition(AllSearchResultsView(searchTerm: searchTerm), transition: 'fade', opaque: true);
      searchTextController.selection = TextSelection(baseOffset: 0, extentOffset: searchTextController.text.length);
      FocusScope.of(context!).previousFocus();
    }
  }

  navigateToCauseView(String id) {
    _navigationService!.navigateTo(Routes.CauseViewRoute(id: id));
  }

  navigateToUserView(String id) {
    _navigationService!.navigateTo(Routes.UserProfileViewRoute(id: id));
  }

  navigateToPreviousView() {
    _navigationService!.popRepeated(1);
  }
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
