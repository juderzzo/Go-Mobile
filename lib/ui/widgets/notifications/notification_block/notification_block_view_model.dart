import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/enums/notifcation_type.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  initialize() async {}

  showOptions() async {
    // var sheetResponse = await _bottomSheetService.showCustomSheet(
    //   variant: isCreator ? BottomSheetType.causeCreatorOptions : BottomSheetType.causeOptions,
    // );
    // if (sheetResponse != null) {
    //   String res = sheetResponse.responseData;
    //   if (res == "edit") {
    //     //edit
    //   } else if (res == "share") {
    //     //share
    //   } else if (res == "report") {
    //     //report
    //   } else if (res == "delete") {
    //     //delete
    //   }
    //   notifyListeners();
    // }
  }

  onTap({String notifType, Map<dynamic, dynamic> data}) {
    if (notifType == NotificationType.newPost.toString() ||
        notifType == NotificationType.postComment.toString() ||
        notifType == NotificationType.postCommentReply.toString()) {
      navigateToPostView(data['postID']);
    }
  }

  ///NAVIGATION
  navigateToCauseView(String id) {
    //_navigationService.navigateTo(Routes.CauseViewRoute, arguments: {'id': id});
  }

  navigateToPostView(String id) {
    _navigationService.navigateTo(Routes.ForumPostViewRoute, arguments: {'postID': id});
  }

  navigateToUserView(String uid) {
    //_navigationService.navigateTo(Routes.UserViewRoute, arguments: {'uid': uid});
  }
}
