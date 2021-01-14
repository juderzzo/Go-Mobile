import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/algolia/algolia_search_service.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllSearchResultsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  AlgoliaSearchService _algoliaSearchService = locator<AlgoliaSearchService>();

  ///HELPERS
  TextEditingController searchTextController = TextEditingController();
  ScrollController causeScrollController = ScrollController();
  ScrollController userScrollController = ScrollController();

  ///DATA RESULTS
  String searchTerm;
  List<GoCause> causesResults = [];
  bool loadingAdditionalCauses = false;
  bool moreCausesAvailable = true;
  int causeResultsPageNum = 1;

  List<GoUser> userResults = [];
  bool loadingAdditionalUsers = false;
  bool moreUsersAvailable = true;
  int userResultsPageNum = 1;

  int resultsLimit = 15;

  initialize(BuildContext context, String searchTermVal) async {
    searchTerm = searchTermVal;
    searchTextController.text = searchTerm;
    notifyListeners();
    causeScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * causeScrollController.position.maxScrollExtent;
      if (causeScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalCauses();
      }
    });
    userScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * userScrollController.position.maxScrollExtent;
      if (userScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalUsers();
      }
    });
    notifyListeners();
    await loadCauses();
    await loadUsers();
    setBusy(false);
  }

  ///CAUSES
  Future<void> refreshCausesFollowing() async {
    causesResults = [];
    notifyListeners();
    await loadCauses();
  }

  loadCauses() async {
    causesResults = await _algoliaSearchService.queryCauses(searchTerm: searchTerm, resultsLimit: resultsLimit);
    causeResultsPageNum += 1;
    notifyListeners();
  }

  loadAdditionalCauses() async {
    if (loadingAdditionalCauses || !moreCausesAvailable) {
      return;
    }
    loadingAdditionalCauses = true;
    notifyListeners();
    List<GoCause> newResults = await _algoliaSearchService.queryAdditionalCauses(
      searchTerm: searchTerm,
      resultsLimit: resultsLimit,
      pageNum: causeResultsPageNum,
    );
    if (newResults.length == 0) {
      moreCausesAvailable = false;
    } else {
      causesResults.addAll(newResults);
      causeResultsPageNum += 1;
    }
    loadingAdditionalCauses = false;
    notifyListeners();
  }

  ///USERS
  Future<void> refreshUsersFollowing() async {
    userResults = [];
    notifyListeners();
    await loadCauses();
  }

  loadUsers() async {
    userResults = await _algoliaSearchService.queryUsers(searchTerm: searchTerm, resultsLimit: resultsLimit);
    userResultsPageNum += 1;
    notifyListeners();
  }

  loadAdditionalUsers() async {
    if (loadingAdditionalUsers || !moreUsersAvailable) {
      return;
    }
    loadingAdditionalUsers = true;
    notifyListeners();
    List<GoUser> newResults = await _algoliaSearchService.queryAdditionalUsers(
      searchTerm: searchTerm,
      resultsLimit: resultsLimit,
      pageNum: userResultsPageNum,
    );
    if (newResults.length == 0) {
      moreUsersAvailable = false;
    } else {
      userResults.addAll(newResults);
      userResultsPageNum += 1;
    }
    loadingAdditionalUsers = false;
    notifyListeners();
  }

  ///NAVIGATION
  navigateToPreviousPage() {
    _navigationService.back();
  }

  navigateToHomePage() {
    _navigationService.popRepeated(2);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
