import 'package:go/app/locator.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/copy_shareable_link.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostSuccessfulBottomSheetModel extends BaseViewModel {
  SnackbarService _snackbarService = locator<SnackbarService>();
  UserDataService _userDataService = locator<UserDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();

  sharePostLink(GoForumPost post) async {
    String authorID = post.authorID;
    var userData = await _userDataService.getGoUserByID(authorID);
    if (userData is String) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'There was an issue sharing your post. Please try again.',
        duration: Duration(seconds: 3),
      );
      return;
    }
    GoUser user = userData;
    String url = await _dynamicLinkService.createPostLink(postAuthorUsername: "@${user.username}", post: post);
    _shareService.shareLink(url);
  }

  copyPostLink(GoForumPost post) async {
    String authorID = post.authorID;
    var userData = await _userDataService.getGoUserByID(authorID);
    if (userData is String) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'There was an issue sharing your post. Please try again.',
        duration: Duration(seconds: 3),
      );
      return;
    }
    GoUser user = userData;
    String url = await _dynamicLinkService.createPostLink(postAuthorUsername: "@${user.username}", post: post);
    copyShareableLink(link: url);
  }
}
