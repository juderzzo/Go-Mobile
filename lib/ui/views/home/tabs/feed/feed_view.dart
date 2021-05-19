import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/list_builders/posts/followed_posts/list_followed_posts.dart';
import 'package:go/ui/widgets/notifications/notification_bell/notification_bell_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'feed_view_model.dart';

class FeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => locator<FeedViewModel>(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                _FeedViewHead(),
                _FeedBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedViewHead extends HookViewModelWidget<FeedViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, FeedViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Home",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NotificationBellView(uid: model.user.id),
                IconButton(
                  onPressed: () => model.customBottomSheetService.showAddCauseBottomSheet(),
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    color: appIconColor(),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListFollowedPosts(),
    );
  }
}
