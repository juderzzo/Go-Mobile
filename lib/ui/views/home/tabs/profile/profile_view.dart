import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/causes/current_user/list_current_user_created_causes.dart';
import 'package:go/ui/widgets/list_builders/posts/liked_posts/list_liked_user_posts.dart';
import 'package:go/ui/widgets/list_builders/posts/user_posts/list_user_posts.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => locator<ProfileViewModel>(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: appBackgroundColor(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                _ProfileViewHead(),
                _ProfileViewBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileViewHead extends HookViewModelWidget<ProfileViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => model.customBottomSheetService.showCurrentUserOptions(model.user),
                icon: Icon(
                  FontAwesomeIcons.ellipsisH,
                  color: appIconColor(),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileViewBody extends HookViewModelWidget<ProfileViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    final _tabController = useTabController(initialLength: 3);
    final _scrollController = useScrollController();
    return Expanded(
      child: DefaultTabController(
        key: PageStorageKey('profile-tab-bar'),
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                expandedHeight: 350,
                backgroundColor: appBackgroundColor(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: Column(
                      children: [
                        _UserDetails(),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: GoProfilePageTabBar(
                    tabController: _tabController,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              ListCurrentUserCreatedCauses(),
              ListUserPosts(id: model.user.id),
              ListLikedUserPosts(id: model.user.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDetails extends HookViewModelWidget<ProfileViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProfileViewModel model) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: model.user.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${model.user.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8),
          FollowStatsRow(
            followersLength: model.user.followers!.length,
            followingLength: model.user.following!.length,
            viewFollowersAction: null,
            viewFollowingAction: null,
            points: model.user.points,
          ),
          Container(
            //height: MediaQuery.of(context).size.height * 4/10,
            child: ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              //controller: new ScrollController(),
              children: [
                model.user.personalSite != null && model.user.personalSite!.isNotEmpty
                    ? GestureDetector(
                        onTap: () => UrlHandler().launchInWebViewOrVC(model.user.personalSite!),
                        child: Container(
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.link,
                                size: 12,
                                color: appFontColor(),
                              ),
                              horizontalSpaceTiny,
                              CustomText(
                                text: model.user.personalSite!,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: appFontColor(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                UserBio(
                  username: model.user.username,
                  profilePicURL: model.user.profilePicURL,
                  bio: model.user.bio,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
