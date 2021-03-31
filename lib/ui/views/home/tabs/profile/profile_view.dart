import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatefulWidget {
  final GoUser user;
  ProfileView({this.user});

  @override
  _ProfileViewState createState() => _ProfileViewState(user: this.user);
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  final GoUser user;
  _ProfileViewState({this.user});
  TabController _tabController;
  List postFutures = [];
  List<Widget> posts = [];
  bool loading = true;
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

  Widget userDetails(model) {
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
            points: widget.user.points,
          ),
          Container(
            //height: MediaQuery.of(context).size.height * 4/10,
            child: ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              //controller: new ScrollController(),
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

  List<Widget> generateLiked(model, fut) {
    List<Widget> ans = [];

    if (fut.length == 0) {
      return [
        Center(
            child: Text(
          "You have not liked any posts yet",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ))
      ];
    }

    //print(fut);
    // for (int i = 0; i < fut.length; i) {
    //   ans.add(FutureBuilder(
    //       future: fut[i],
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.done) {
    //           return Text(snapshot.data[0].toString());
    //         } else {
    //           return Text("loading");
    //         }
    //       }));
    // }

    return ans;
  }

  Widget body(ProfileViewModel model) {
    List<Widget> loader = [];
    loader.add(
      Padding(
        padding: const EdgeInsets.all(138.0),
        child: Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator()),
      )
      );

    return TabBarView(
      controller: _tabController,
      children: [
        Container(
          child: RefreshIndicator(
              onRefresh: () async {
                posts = [];
                makeList();
                await model.notifyListeners();
              },
              child: ListView(
                  shrinkWrap: true, children: loading ? loader : posts)),
        ),
        ListCauses(
          refreshData: model.refreshCausesFollowing,
          causesResults: model.causesFollowingResults,
          pageStorageKey: PageStorageKey('profile-causes-following'),
          scrollController: null,
        ),
        RefreshIndicator(
          onRefresh: () async {
            model.initialize(_tabController, user);
            await model.notifyListeners();
          },
          child: ListView(
            children: model.loadPosts().runtimeType == Null
                ? loader
                : model.loadPosts(),
          ),
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
    makeList();
  }

  void makeList() async {
    //have to optimize this
    for (int i = 0; i < user.liked.length; i++) {
      dynamic u = await ProfileViewModel.generatePost(i, user.id);
      //await u;
      print(i);
      if (u.runtimeType != Future) {
        if (u == null) {
          print("nullify");
          user.liked.removeAt(i);
          ProfileViewModel.updateLiked(user.id, user.liked);
        } else if (u.runtimeType == GoForumPost && u != null) {
          posts.add(ForumPostBlockView(
            post: u,
            displayBottomBorder: (i != user.liked.length),
          ));
        }
      }
    }
    //print(posts.length);
    //print(posts.toString());
    if (posts.length == user.liked.length) {
      loading = false;
      setState(() {});
    }
    //print(loading);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = true;

    return ViewModelBuilder<ProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(_tabController, widget.user),
      viewModelBuilder: () => locator<ProfileViewModel>(),
      builder: (context, model, child) => ChangeNotifierProvider.value(
        value: model,
        child: Container(
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
                              expandedHeight: MediaQuery.of(context).size.height * 7/13,
                              backgroundColor: appBackgroundColor(),
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  child: Column(
                                    children: [
                                      widget.user == null
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
                        body: body(model),
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
