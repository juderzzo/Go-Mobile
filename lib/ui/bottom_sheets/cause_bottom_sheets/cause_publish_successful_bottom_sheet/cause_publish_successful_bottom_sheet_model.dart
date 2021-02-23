import 'package:go/app/locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/utils/copy_shareable_link.dart';
import 'package:stacked/stacked.dart';

class CausePublishSuccessfulBottomSheetModel extends BaseViewModel {
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ShareService _shareService = locator<ShareService>();

  shareCauseLink(GoCause cause) async {
    String url = await _dynamicLinkService.createCauseLink(cause: cause);
    _shareService.shareLink(url);
  }

  copyPostLink(GoCause cause) async {
    String url = await _dynamicLinkService.createCauseLink(cause: cause);
    copyShareableLink(link: url);
  }
}
