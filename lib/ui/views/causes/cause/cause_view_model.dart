import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseViewModel extends StreamViewModel<GoCause> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();

  ///HELPERS
  ScrollController postsScrollController = ScrollController();

  ///DATA
  String currentUID;
  GoUser user;
  String causeID;
  GoCause cause;
  GoUser causeCreator;
  List images = [];
  bool isFollowingCause;
  bool loadedImages = false;
  bool refreshingPosts = false;
  bool isAdmin = false;

  ///DATA RESULTS
  List<GoCheckListItem> checkListItems = [];
  List<DocumentSnapshot> postResults = [];
  bool loadingAdditionalPosts = false;
  bool morePostsAvailable = true;
  int tab = -1;

  int resultsLimit = 15;

  initialize(BuildContext context) async {
    setBusy(true);
    currentUID = await _authService.getCurrentUserID();
    Map<String, dynamic> args = RouteData.of(context).arguments;
    causeID = args['id'];
    if(args['tab'] != null){
      tab = args['tab'];
      
    }
    
    cause = await _causeDataService.getCauseByID(causeID);
    String causeCreatorID = cause.creatorID;
    isAdmin = (causeCreatorID == currentUID || cause.admins.contains(currentUID));
    
    //eventually add the admins feature
    
   

    
    
    notifyListeners();

    ///SET SCROLL CONTROLLER
    postsScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * postsScrollController.position.maxScrollExtent;
      if (postsScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalPosts();
      }
    });
    notifyListeners();
  }

  getCauseCreator(String id) async {
    var res = await _userDataService.getGoUserByID(id);
    if (res is String) {
      _dialogService.showDialog(
        title: "Cause Creator Error",
        description: "There was an issue loading the details of the creator of this cause",
        barrierDismissible: true,
      );
    } else {
      causeCreator = res;
    }
    notifyListeners();
  }

  followUnfollowCause() {
    _causeDataService.followUnfollowCause(causeID, currentUID);
  }

  ///CHECK LIST ITEMS
  loadCheckListItems() async {
    checkListItems = await _causeDataService.getCheckListItems(cause.id);
    notifyListeners();
  }

  checkOffItem(GoCheckListItem item) async {
    List checkedOffBy = item.checkedOffBy.toList(growable: true);
    if (!checkedOffBy.contains(currentUID)) {
      DialogResponse response = await _dialogService.showConfirmationDialog(
        title: "Are You Sure You've Completed this Task?",
        description: "Checking off this task is irreversible",
        cancelTitle: "Cancel",
        confirmationTitle: "Confirm",
        barrierDismissible: true,
      );
      if (response.confirmed) {
        //validate location if required
        if (item.lat != null && item.lon != null && item.address != null) {
          bool isNearbyLocation = await _locationService.isNearbyLocation(lat: item.lat, lon: item.lon);
          if (!isNearbyLocation) {
            _dialogService.showDialog(
              title: "Location Error",
              description: "You are not near the required location to check off this item.",
              buttonTitle: "Ok",
            );
            return;
          }
        }
        //check off item
        checkedOffBy.add(currentUID);
        await _causeDataService.checkOffCheckListItem(id: item.id, checkedOffBy: checkedOffBy);
      }
    }
  }

  ///LOAD POSTS
  Future<void> refreshPosts() async {
    refreshingPosts = true;
    postResults = [];
    notifyListeners();
    await loadPosts();
  }

  loadPosts() async {
    postResults = await _postDataService.loadPosts(
      resultsLimit: resultsLimit,
      causeID: cause.id,
    );
    refreshingPosts = false;
    notifyListeners();
  }

  loadAdditionalPosts() async {
    if (loadingAdditionalPosts || !morePostsAvailable) {
      return;
    }
    loadingAdditionalPosts = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _postDataService.loadAdditionalPosts(
      lastDocSnap: postResults[postResults.length - 1],
      resultsLimit: resultsLimit,
      causeID: cause.id,
    );
    if (newResults.length == 0) {
      morePostsAvailable = false;
    } else {
      postResults.addAll(newResults);
    }
    loadingAdditionalPosts = false;
    notifyListeners();
  }

  ///STREAM CAUSE DATA
  @override
  void onData(GoCause data) {
    if (data != null) {
      cause = data;
      if (cause.followers.contains(currentUID)) {
        isFollowingCause = true;
      } else {
        isFollowingCause = false;
      }
      if (!loadedImages) {
        cause.imageURLs.forEach((url) {
          images.add(
            NetworkImage(url),
          );
        });
        loadedImages = true;
      }
      getCauseCreator(cause.creatorID);
      loadCheckListItems();
      loadPosts();
      notifyListeners();
      setBusy(false);
    }
  }

  @override
  Stream<GoCause> get stream => streamCause();

  Stream<GoCause> streamCause() async* {
    while (true) {
      if (causeID == null) {
        yield null;
      }
      await Future.delayed(Duration(seconds: 1));
      var res = await _causeDataService.getCauseByID(causeID);
      if (res is String) {
        yield null;
      } else {
        yield res;
      }
    }
  }

  ///NAVIGATION
  navigateToCreatePostView() async {
    String data = await _navigationService.navigateTo(Routes.CreateForumPostViewRoute, arguments: {'causeID': cause.id});
    if (data == 'newPostCreated') {
      refreshPosts();
    }
  }

  navigateBack() {
    _navigationService.back();
  }
}
