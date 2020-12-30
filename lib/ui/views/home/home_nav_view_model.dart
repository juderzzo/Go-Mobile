import 'package:go/app/locator.dart';
import 'package:go/enums/init_error_status.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/utils/network_status.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeNavViewModel extends StreamViewModel<GoUser> {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  InitErrorStatus initErrorStatus = InitErrorStatus.network;
  GoUser user;
  String initialCityName;
  String initialAreaCode;

  //Tab Bar State
  int _navBarIndex = 0;
  int get navBarIndex => _navBarIndex;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }

  initialize() async {
    setBusy(true);
    isConnectedToNetwork().then((connected) {
      if (!connected) {
        initErrorStatus = InitErrorStatus.network;
        setBusy(false);
        notifyListeners();
        _snackbarService.showSnackbar(
          title: 'Network Error',
          message: "There Was an Issue Connecting to the Internet",
          duration: Duration(seconds: 5),
        );
      } else {
        initErrorStatus = InitErrorStatus.none;
        setBusy(false);
        notifyListeners();
      }
    });
  }

  Future<bool> isConnectedToNetwork() async {
    bool isConnected = await NetworkStatus().isConnected();
    return isConnected;
  }

  @override
  void onData(GoUser data) {
    if (data != null) {
      user = data;
      notifyListeners();
    }
  }

  @override
  Stream<GoUser> get stream => streamUser();

  Stream<GoUser> streamUser() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      String uid = await _authService.getCurrentUserID();
      var res = await _userDataService.getGoUserByID(uid);
      if (res is String) {
        yield null;
      } else {
        yield res;
      }
    }
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
