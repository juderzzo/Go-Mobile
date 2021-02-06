import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/user/user_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class UserView extends StatefulWidget {
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head(BuildContext context, UserViewModel model) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => model.navigateToPreviousPage(),
                icon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: appIconColor(),
                  size: 20,
                ),
              ),
              CustomFittedText(
                text: model.user == null ? "" : "${model.user.username}",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appFontColor(),
                textAlign: TextAlign.left,
                height: 30,
                width: 200,
              ),
            ],
          ),
          // IconButton(
          //   onPressed: () => model.navigateToPreviousPage(),
          //   icon: Icon(
          //     FontAwesomeIcons.commentDots,
          //     color: appIconColor(),
          //     size: 20,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget userDetails(UserViewModel model) {
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
            followersLength: model.user.followers.length,
            followingLength: model.user.following.length,
            viewFollowersAction: null,
            viewFollowingAction: null,
          ),
          SizedBox(height: 28),
          model.isFollowing == null || model.isFollowing == false
              ? CustomButton(
                  isBusy: false,
                  text: "Follow",
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: () {
                    model.isFollowing = !model.isFollowing;
                    model.followUnfollowUser();
                  })
              : CustomButton(
                  isBusy: false,
                  text: "Following",
                  elevation: 0.0,
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: () {
                    model.isFollowing = !model.isFollowing;
                    model.followUnfollowUser();
                  }
                ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return GoProfileTabBar(
      //key: PageStorageKey('profile-tab-bar'),
      tabController: _tabController,
    );
  }

  Widget body(UserViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              verticalSpaceLarge,
              UserBio(
                username: model.user.username,
                profilePicURL: model.user.profilePicURL,
                bio: model.user.bio,
              ),
            ],
          ),
        ),
        ListCauses(
          refreshData: model.refreshCausesFollowing,
          causesResults: model.causesFollowingResults,
          pageStorageKey: PageStorageKey('user-causes-following'),
          scrollController: null,
        ),
        ListCauses(
          refreshData: model.refreshCausesCreated,
          causesResults: model.causesCreatedResults,
          pageStorageKey: PageStorageKey('user-causes-created'),
          scrollController: null,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(_tabController, context),
      viewModelBuilder: () => UserViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor(),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  head(context, model),
                  Expanded(
                    child: DefaultTabController(
                      key: PageStorageKey('user-tab-bar'),
                      length: 4,
                      child: NestedScrollView(
                        controller: model.scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              leading: Container(),
                              pinned: true,
                              floating: true,
                              forceElevated: innerBoxIsScrolled,
                              expandedHeight: 260,
                              backgroundColor: appBackgroundColor(),
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  child: Column(
                                    children: [
                                      model.user == null
                                          ? Container()
                                          : userDetails(model),
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
                        body: model.user == null ? Container() : body(model),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
