import 'package:go/app/app.locator.dart';
import 'package:go/enums/init_error_status.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_messaging_service.dart';
import 'package:go/utils/network_status.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeNavViewModel extends StreamViewModel<GoUser> {
  ///SERVICES
  AuthService? _authService = locator<AuthService>();
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  UserDataService? _userDataService = locator<UserDataService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  DynamicLinkService? _dynamicLinkService = locator<DynamicLinkService>();
  FirebaseMessagingService? _firebaseMessagingService = locator<FirebaseMessagingService>();

  ///INITIAL DATA
  InitErrorStatus initErrorStatus = InitErrorStatus.network;

  ///CURRENT USER
  GoUser? user;

  ///TAB BAR STATE
  int _navBarIndex = 0;
  int get navBarIndex => _navBarIndex;

  //notifs
  bool configuredFirebaseMessaging = false;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }

  bool initialized = false;

  initialize() async {
    setBusy(true);
    bool connectedToNetwork = await isConnectedToNetwork();
    if (!connectedToNetwork) {
      initErrorStatus = InitErrorStatus.network;
      notifyListeners();
      setBusy(false);
      _snackbarService!.showSnackbar(
        title: 'Network Error',
        message: "There Was an Issue Connecting to the Internet",
        duration: Duration(seconds: 5),
      );
    } else {
      initErrorStatus = InitErrorStatus.none;
      await _dynamicLinkService!.handleDynamicLinks();
      // _firebaseMessagingService.configFirebaseMessaging();
      // _firebaseMessagingService.updateFirebaseMessageToken(user.id);
      notifyListeners();
    }
    initialized = true;
  }

  Future<bool> isConnectedToNetwork() async {
    bool isConnected = await NetworkStatus().isConnected();
    return isConnected;
  }

  @override
  void onData(GoUser? data) {
    if (data != null) {
      user = data;
      if (!configuredFirebaseMessaging) {
        _firebaseMessagingService!.configFirebaseMessaging();
        _firebaseMessagingService!.updateFirebaseMessageToken(user!.id);
        configuredFirebaseMessaging = true;
      }

      notifyListeners();
      setBusy(false);
    }
  }

  @override
  Stream<GoUser> get stream => streamUser();

  Stream<GoUser> streamUser() async* {
    while (true) {
      GoUser user = GoUser();
      await Future.delayed(Duration(seconds: 1));
      String? uid = await _authService!.getCurrentUserID();
      user = (await _userDataService!.getGoUserByID(uid))!;
      yield user;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //super.dispose();
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
