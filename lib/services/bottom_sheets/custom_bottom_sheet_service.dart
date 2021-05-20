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
  CustomNavigationService _customNavigationService =
      locator<CustomNavigationService>();

  Future<String?> showImageSelectorBottomSheet() async {
    String? source;
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.imagePicker,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;

      //get image from camera or gallery
      source = res;
    }
    return source;
  }

  showCurrentUserOptions(GoUser user) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.currentUserOptions,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "edit profile") {
        //edit profile
        _navigationService.navigateTo(Routes.EditProfileViewRoute);
      } else if (res == "share profile") {
        //share profile
        String? url = await _dynamicLinkService.createProfileLink(user: user);
        _shareService.shareLink(url);
      } else if (res == "settings") {
        _navigationService.navigateTo(Routes.SettingsViewRoute);
      }
    }
  }

  showAddCauseBottomSheet() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: BottomSheetType.addCause,
    );
    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "new cause") {
        _navigationService.navigateTo(Routes.CreateCauseViewRoute(id: "new"));
      }
    }
  }

  showCausePublishedBottomSheet(GoCause cause) async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.causePublished,
      takesInput: false,
      barrierDismissible: false,
      customData: cause,
    );
    if (sheetResponse == null || sheetResponse.responseData == "return") {
      _navigationService.pushNamedAndRemoveUntil(Routes.AppBaseViewRoute);
    }
  }

  Future showContentOptions({required dynamic content}) async {
    GoUser user = _reactiveUserService.user;
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      variant: content is GoCause
          ? content.admins!.contains(user.id) || content.creatorID == user.id
              ? BottomSheetType.causeCreatorOptions
              : BottomSheetType.causeOptions
          : user.id == content.authorID
              ? BottomSheetType.postAuthorOptions
              : BottomSheetType.postOptions,
    );

    if (sheetResponse != null) {
      String? res = sheetResponse.responseData;
      if (res == "edit") {
        if (content is GoCause) {
          //edit cause
          _navigationService
              .navigateTo(Routes.CreateCauseViewRoute(id: content.id));
        } else if (content is GoForumPost) {
          //edit post
          _navigationService.navigateTo(Routes.CreateForumPostViewRoute(
              causeID: content.causeID, id: content.id));
        }
      } else if (res == "share") {
        if (content is GoCause) {
          //share cause link
          String url =
              await _dynamicLinkService.createCauseLink(cause: content);
          _shareService.shareLink(url);
        } else if (content is GoForumPost) {
          //share post link
          String url = await _dynamicLinkService.createPostLink(post: content);
          _shareService.shareLink(url);
        }
      } else if (res == "report") {
        if (content is GoCause) {
          //report cause
          if (user.id == content.creatorID) {
            bool deletedContent =
                await deleteContentConfirmation(content: content);
            if (deletedContent) {
              return "deleted content";
            }
          } else {
            _causeDataService.reportCause(
                causeID: content.id, reporterID: user.id);
          }
        } else if (content is GoForumPost) {
          //report post
          if (user.id == content.authorID) {
            bool deletedContent =
                await deleteContentConfirmation(content: content);
            if (deletedContent) {
              return "deleted content";
            }
          } else {
            _postDataService.reportPost(
                postID: content.id, reporterID: user.id);
          }
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
