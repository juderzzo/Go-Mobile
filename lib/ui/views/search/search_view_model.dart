import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/services/algolia/algolia_search_service.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();

  ///SEARCH
  List<String> recentSearchTerms = [];
  List<SearchResult> causeResults = [];
  List<SearchResult> userResults = [];

  initialize() {}

  querySearchResults(String searchTerm) async {
    setBusy(true);
    int causesResultsLimit = 5;
    int userResultsLimit = 16;
    if (searchTerm == null || searchTerm.trim().isEmpty) {
      await Future.delayed(Duration(seconds: 2));
      causeResults = [];
      userResults = [];
    } else {
      causeResults = await _algoliaSearchService.queryCauses(searchTerm: searchTerm, resultsLimit: causesResultsLimit);
      userResults = await _algoliaSearchService.queryUsers(searchTerm: searchTerm, resultsLimit: userResultsLimit);
    }
    setBusy(false);
    notifyListeners();
  }

  ///NAVIGATION
  navigateToPreviousPage() {
    _navigationService.popRepeated(1);
  }
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
