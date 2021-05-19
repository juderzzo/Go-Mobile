import 'package:go/app/app.locator.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/copy_shareable_link.dart';
import 'package:stacked/stacked.dart';

class ForumPostSuccessfulBottomSheetModel extends BaseViewModel {
  DynamicLinkService? _dynamicLinkService = locator<DynamicLinkService>();
  ShareService? _shareService = locator<ShareService>();

  sharePostLink(GoForumPost post) async {
    String url = await _dynamicLinkService!.createPostLink(post: post);
    _shareService!.shareLink(url);
  }

  copyPostLink(GoForumPost post) async {
    String url = await _dynamicLinkService!.createPostLink(post: post);
    copyShareableLink(link: url);
  }
}
