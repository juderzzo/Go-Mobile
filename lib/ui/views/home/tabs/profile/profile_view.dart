import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatefulWidget {
  final GoUser user;
  ProfileView({this.user});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head(ProfileViewModel model) {
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
                onPressed: () => model.showOptions(),
                icon: Icon(
                  FontAwesomeIcons.ellipsisH,
                  color: appIconColor(),
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => model.navigateToSettingsPage(),
                icon: Icon(
                  FontAwesomeIcons.cog,
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

  Widget userDetails() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: widget.user.profilePicURL,
            size: 60,
            isBusy: false,
          ),
          SizedBox(height: 8),
          Text(
            "@${widget.user.username}",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8),
          FollowStatsRow(
            followersLength: widget.user.followers.length,
            followingLength: widget.user.following.length,
            viewFollowersAction: null,
            viewFollowingAction: null,
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

  Widget body(ProfileViewModel model) {
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
          pageStorageKey: PageStorageKey('profile-causes-following'),
          scrollController: null,
        ),
        ListCauses(
          refreshData: model.refreshCausesCreated,
          causesResults: model.causesCreatedResults,
          pageStorageKey: PageStorageKey('profile-causes-created'),
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
    return ViewModelBuilder<ProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(_tabController, widget.user),
      viewModelBuilder: () => locator<ProfileViewModel>(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: appBackgroundColor(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                head(model),
                Expanded(
                  child: DefaultTabController(
                    key: PageStorageKey('profile-tab-bar'),
                    length: 4,
                    child: NestedScrollView(
                      controller: model.scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            pinned: true,
                            floating: true,
                            forceElevated: innerBoxIsScrolled,
                            expandedHeight: 200,
                            backgroundColor: appBackgroundColor(),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                child: Column(
                                  children: [
                                    widget.user == null ? Container() : userDetails(),
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
                      body: body(model),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
