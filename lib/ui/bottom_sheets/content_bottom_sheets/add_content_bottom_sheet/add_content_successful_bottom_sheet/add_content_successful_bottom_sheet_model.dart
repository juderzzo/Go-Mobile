import 'package:go/app/app.locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/copy_shareable_link.dart';
import 'package:stacked/stacked.dart';

class AddContentSuccessfulBottomSheetModel extends BaseViewModel {
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  shareContentLink(dynamic content) async {
    String? url;
    if (content is GoCause) {
      url = await _dynamicLinkService.createCauseLink(cause: content);
    } else if (content is GoForumPost) {
      url = await _dynamicLinkService.createPostLink(postAuthorUsername: "@${_reactiveUserService.user.username}", post: content);
    }
    _shareService.shareLink(url!);
  }

  copyContentLink(dynamic content) async {
    String? url;
    if (content is GoCause) {
      url = await _dynamicLinkService.createCauseLink(cause: content);
    } else if (content is GoForumPost) {
      url = await _dynamicLinkService.createPostLink(postAuthorUsername: "@${_reactiveUserService.user.username}", post: content);
    }
    copyShareableLink(link: url);
  }
}
