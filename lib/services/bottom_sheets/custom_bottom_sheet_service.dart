import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class CustomBottomSheetService {
  ThemeService _themeService = locator<ThemeService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  AuthService _authService = locator<AuthService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  UserDataService? _userDataService = locator<UserDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  PostDataService _postDataService = locator<PostDataService>();
  CustomNavigationService _customNavigationService = locator<CustomNavigationService>();
  showCurrentUserOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.currentUserOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "edit") {
        //saved
      } else if (res == "share") {
        //edit profile
        //navigateToEditProfileView();
      } else if (res == "settings") {
        _customNavigationService.navigateToSettingsView();
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

  Future showContentOptions({required dynamic content}) async {
    GoUser user = _reactiveUserService.user;
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: user.id == content.authorID ? BottomSheetType.contentAuthorOptions : BottomSheetType.contentOptions,
    );

    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "edit") {
        if (content is GoCause) {
          //edit post
          //_navigationService.navigateTo(Routes.CreatePostViewRoute(id: content.id, promo: 0));
        } else if (content is GoForumPost) {
          //edit event
          // _navigationService.navigateTo(Routes.CreateEventViewRoute(id: content.id, promo: 0));
        }
      } else if (res == "share") {
        if (content is GoCause) {
          //share cause link

        } else if (content is GoForumPost) {
          //share post link

        }
      } else if (res == "report") {
        if (content is GoCause) {
          //report cause
          //_causeDataService.reportCause(postID: content.id, reporterID: user.id);
        } else if (content is GoForumPost) {
          //report post
          //_postDataService.reportPost(eventID: content.id, reporterID: user.id);
        }
      } else if (res == "delete") {
        //delete content
        bool deletedContent = await deleteContentConfirmation(content: content);
        if (deletedContent) {
          return "deleted content";
        }
      }
    }
  }

  //bottom sheet for confirming the removal of a post, event, or stream
  Future<bool> deleteContentConfirmation({dynamic content}) async {
    if (content is GoCause) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        title: "Delete Cause",
        description: "Are You Sure You Want to Delete this Cause?",
        mainButtonTitle: "Delete Cause",
        secondaryButtonTitle: "Cancel",
        barrierDismissible: true,
        variant: BottomSheetType.destructiveConfirmation,
      );
      if (sheetResponse != null) {
        String? res = sheetResponse.responseData;
        if (res == "confirmed") {
          _causeDataService.deleteCause(content.id);
          _customDialogService.showCauseDeletedDialog();
          return true;
        }
      }
    } else if (content is GoForumPost) {
      var sheetResponse = await _bottomSheetService.showCustomSheet(
        title: "Delete Post",
        description: "Are You Sure You Want to Delete this Post?",
        mainButtonTitle: "Delete Post",
        secondaryButtonTitle: "Cancel",
        barrierDismissible: true,
        variant: BottomSheetType.destructiveConfirmation,
      );
      if (sheetResponse != null) {
        String? res = sheetResponse.responseData;
        if (res == "confirmed") {
          _postDataService.deletePost(content.id);
          _customDialogService.showPostDeletedDialog();
          return true;
        }
      }
    }
    return false;
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
        await _authService.signOut();
        _reactiveUserService.updateUserLoggedIn(false);
        _reactiveUserService.updateUser(GoUser());
        _navigationService.pushNamedAndRemoveUntil(Routes.RootViewRoute);
      }
    }
  }
}
