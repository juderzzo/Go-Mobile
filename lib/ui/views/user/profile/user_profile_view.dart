import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/user/profile/user_profile_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/causes/user/list_user_created_causes.dart';
import 'package:go/ui/widgets/list_builders/posts/liked_posts/list_liked_user_posts.dart';
import 'package:go/ui/widgets/list_builders/posts/user_posts/list_user_posts.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/user/follow_unfollow_button.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class UserProfileView extends StatefulWidget {
  final String? id;
  UserProfileView(@PathParam() this.id);
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Widget head(UserProfileViewModel model) {
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
                onPressed: () => model.showUserOptions(),
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

  Widget userDetails(UserProfileViewModel model) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: model.user!.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${model.user!.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8),
          model.isFollowingUser == null
              ? Container()
              : Container(
                  width: 100,
                  child: FollowUnfollowButton(isFollowing: model.isFollowingUser, followUnfollowAction: () => model.followUnfollowUser()),
                ),

          ///BIO & WEBSITE
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: Column(
              children: [
                model.user!.bio != null && model.user!.bio!.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 4),
                        child: CustomText(
                          text: model.user!.bio!,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                        ),
                      )
                    : Container(),
                model.user!.personalSite != null && model.user!.personalSite!.isNotEmpty
                    ? GestureDetector(
                        onTap: () => model.viewWebsite(),
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
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
                                text: model.user!.personalSite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: appFontColor(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return GoProfilePageTabBar(
      //key: PageStorageKey('profile-tab-bar'),
      tabController: _tabController,
    );
  }

  Widget body(UserProfileViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        //causes
        ListUserCreatedCauses(),

        //posts
        ListUserPosts(id: widget.id),

        //liked posts
        ListLikedUserPosts(id: widget.id),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, //4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(id: widget.id),
      viewModelBuilder: () => UserProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicActionAppBar(
          title: model.user == null ? "" : model.user!.username!,
          showBackButton: true,
          actionWidget: IconButton(
            onPressed: () => model.showUserOptions(),
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ),
        body: Container(
          height: screenHeight(context),
          width: screenWidth(context),
          color: appBackgroundColor(),
          child: model.isBusy
              ? Column(
                  children: [
                    CustomLinearProgressIndicator(color: appActiveColor()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: DefaultTabController(
                        key: null,
                        length: 4,
                        child: NestedScrollView(
                          key: null,
                          controller: model.scrollController,
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                key: null,
                                pinned: true,
                                floating: true,
                                snap: true,
                                forceElevated: innerBoxIsScrolled,
                                expandedHeight: ((model.user!.bio != null && model.user!.bio!.isNotEmpty) ||
                                        (model.user!.personalSite != null && model.user!.personalSite!.isNotEmpty))
                                    ? 250
                                    : 200,
                                leading: Container(),
                                backgroundColor: appBackgroundColor(),
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Container(
                                    child: Column(
                                      children: [
                                        model.user == null ? Container() : userDetails(model),
                                      ],
                                    ),
                                  ),
                                ),
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(40),
                                  child: tabBar(),
                                ),
                              ),
                            ];
                          },
                          body: model.isBusy ? Container() : body(model),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
