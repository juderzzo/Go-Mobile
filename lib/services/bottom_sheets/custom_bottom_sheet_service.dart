import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class CustomBottomSheetService {
  ThemeService _themeService = locator<ThemeService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  CustomDialogService? _customDialogService = locator<CustomDialogService>();
  AuthService? _authService = locator<AuthService>();
  ReactiveUserService? _reactiveUserService = locator<ReactiveUserService>();
  UserDataService? _userDataService = locator<UserDataService>();
  DynamicLinkService? _dynamicLinkService = locator<DynamicLinkService>();
  ShareService? _shareService = locator<ShareService>();
  PostDataService? _postDataService = locator<PostDataService>();

  showCurrentUserOptions(GoUser user) async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.currentUserOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "saved") {
        //saved
      } else if (res == "edit profile") {
        //edit profile
        //navigateToEditProfileView();
      } else if (res == "share profile") {
        //share profile
        // String url = await _dynamicLinkService.createProfileLink(user: user);
        // _shareService.copyContentLink(contentType: "profile", url: url);
      } else if (res == "log out") {
        showLogoutBottomSheet();
      }
    }
  }

  showAddContentOptions() async {
    // var sheetResponse = await _bottomSheetService.showCustomSheet(
    //   barrierDismissible: true,
    //   variant: BottomSheetType.addContent,
    // );
    // if (sheetResponse != null) {
    //   String? res = sheetResponse.responseData;
    //   if (res == "new post") {
    //     _navigationService.navigateTo(Routes.CreatePostViewRoute(id: "new", promo: 0));
    //   } else if (res == "new stream") {
    //     _navigationService.navigateTo(Routes.CreateLiveStreamViewRoute(id: "new", promo: 0));
    //   } else if (res == "new event") {
    //     _navigationService.navigateTo(Routes.CreateEventViewRoute(id: "new", promo: 0));
    //   }
    // }
  }

  showLogoutBottomSheet() async {
    var sheetResponse = await _bottomSheetService!.showCustomSheet(
      title: "Log Out",
      description: "Are You Sure You Want to Log Out?",
      mainButtonTitle: "Log Out",
      secondaryButtonTitle: "Cancel",
      barrierDismissible: true,
      variant: BottomSheetType.destructiveConfirmation,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "confirmed") {
        await _authService!.signOut();
        _reactiveUserService!.updateUserLoggedIn(false);
        _reactiveUserService!.updateUser(GoUser());
        _navigationService.pushNamedAndRemoveUntil(Routes.RootViewRoute);
      }
    }
  }
}
