import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view.dart';
import 'package:go/ui/views/causes/cause/cause_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/list_builders/check_list_items/list_cause_check_list_items.dart';
import 'package:go/ui/widgets/list_builders/posts/cause_posts/list_cause_posts.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'cause_detail_views/admin/adminview.dart';

class CauseView extends StatelessWidget {
  final String? id;
  CauseView({@PathParam() this.id});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseViewModel>.reactive(
      onModelReady: (model) => model.initialize(id!),
      viewModelBuilder: () => CauseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicActionAppBar(
          title: model.isBusy ? "" : model.cause!.name!,
          showBackButton: true,
          actionWidget: model.isBusy
              ? Container()
              : IconButton(
                  onPressed: () => model.navigateToCreatePostView(),
                  icon: Icon(FontAwesomeIcons.edit, color: appFontColor(), size: 18),
                ),
        ),
        body: model.isBusy
            ? Center(child: CustomCircleProgressIndicator(color: appActiveColor(), size: 48))
            : model.isAdmin
                ? _AdminCauseViewBody()
                : _CauseViewBody(),
      ),
    );
  }
}

class _CauseViewBody extends HookViewModelWidget<CauseViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CauseViewModel model) {
    final _tabController = useTabController(initialLength: 3);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GoCauseViewTabBar(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AboutView(
                  cause: model.cause,
                  images: model.images,
                  creatorUsername: "@${model.causeCreator!.username}",
                  creatorProfilePicURL: model.causeCreator!.profilePicURL,
                  viewCreator: null,
                  isFollowing: model.isFollowingCause,
                  followUnfollowCause: () => model.followUnfollowCause(),
                ),
                ListCauseCheckListItems(causeID: model.cause!.id!, isAdmin: model.isAdmin),
                ListCausePosts(causeID: model.cause!.id!, ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminCauseViewBody extends HookViewModelWidget<CauseViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CauseViewModel model) {
    final _tabController = useTabController(initialLength: 4);
    return Container(
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GoCauseViewAdminTabBar(tabController: _tabController),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AboutView(
                  cause: model.cause,
                  images: model.images,
                  creatorUsername: "@${model.causeCreator!.username}",
                  creatorProfilePicURL: model.causeCreator!.profilePicURL,
                  viewCreator: null,
                  isFollowing: model.isFollowingCause,
                  followUnfollowCause: () => model.followUnfollowCause(),
                ),
                ListCauseCheckListItems(causeID: model.cause!.id!, isAdmin: model.isAdmin,),
                ListCausePosts(causeID: model.cause!.id!),
                AdminView(
                  cause: model.cause!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
