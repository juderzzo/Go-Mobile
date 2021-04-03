import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view.dart';
import 'package:go/ui/views/causes/cause/cause_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_posts.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';

import 'cause_detail_views/admin/adminview.dart';

class CauseView extends StatefulWidget {
  @override
  _CauseViewState createState() => _CauseViewState();
}

class _CauseViewState extends State<CauseView> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool openAdmins = false;

  Widget head(CauseViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => model.navigateBack(),
                icon: Icon(FontAwesomeIcons.angleLeft, color: appFontColor(), size: 24),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * .7,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: CustomFittedText(
                      text: model.cause.name,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appFontColor(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          IconButton(
            onPressed: () => model.navigateToCreatePostView(),
            icon: Icon(FontAwesomeIcons.edit, color: appFontColor(), size: 18),
          ),
        ],
      ),
    );
  }

  Widget tabBar(model) {
    return GoCauseViewTabBar(
      tabController: _tabController,
      isAdmin: model.isAdmin,
    );
  }

  Widget body(CauseViewModel model) {
    return Expanded(
      child: DefaultTabController(
        length: !model.isAdmin ? 3 : 4,
        child: 
        TabBarView(
          controller: _tabController,
          children: !model.isAdmin ? [
            model.causeCreator == null
                ? Container()
                : AboutView(
                    cause: model.cause,
                    images: model.images,
                    creatorUsername: "@${model.causeCreator.username}",
                    creatorProfilePicURL: model.causeCreator.profilePicURL,
                    viewCreator: null,
                    isFollowing: model.isFollowingCause,
                    followUnfollowCause: () => model.followUnfollowCause(),
                  ),
            CheckListView(
                checkListItems: model.checkListItems,
                isCauseAdmin: model.currentUID == model.cause.creatorID ? true : false,
                causeID: model.cause.id,
                currentUID: model.currentUID,
                checkOffItem: (item) => model.checkOffItem(item),
                refreshData: () {}),
            ListPosts(
              refreshingData: model.refreshingPosts,
              refreshData: () => model.refreshPosts(),
              postResults: model.postResults,
              scrollController: model.postsScrollController,
            ),

          ] : [
            model.causeCreator == null
                ? Container()
                : AboutView(
                    cause: model.cause,
                    images: model.images,
                    creatorUsername: "@${model.causeCreator.username}",
                    creatorProfilePicURL: model.causeCreator.profilePicURL,
                    viewCreator: null,
                    isFollowing: model.isFollowingCause,
                    followUnfollowCause: () => model.followUnfollowCause(),
                  ),
            CheckListView(
                checkListItems: model.checkListItems,
                isCauseAdmin: model.currentUID == model.cause.creatorID ? true : false,
                causeID: model.cause.id,
                currentUID: model.currentUID,
                checkOffItem: (item) => model.checkOffItem(item),
                refreshData: () {}),
            ListPosts(
              refreshingData: model.refreshingPosts,
              refreshData: () => model.refreshPosts(),
              postResults: model.postResults,
              scrollController: model.postsScrollController,
            ),

            AdminView(
              cause: model.cause,
              admin: openAdmins,
            )

          ]
          ,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    
  }

  //this is for reloading the amdin page after you add a cause
  

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseViewModel>.reactive(
        onModelReady: (model){
          
          model.initialize(context).then((v){
            print("Is admin: ${model.isAdmin}");
          _tabController = TabController(
            length: model.isAdmin ? 4 : 3,
            vsync: this,
            initialIndex: model.tab > -1 ? model.tab : 0
            //initialIndex: model.tab > -1 ? model.tab : 0
          );
          if(model.tab == 3) {
            
            openAdmins = true;
          }

          });
          
        

          
        },
        viewModelBuilder: () => CauseViewModel(),
        builder: (context, model, child) => OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape && _tabController.index == 0) {
                  return body(model);
                } else {
                  return Scaffold(
                    appBar: CustomAppBar().basicActionAppBar(
                      title: model.isBusy ? "" : model.cause.name,
                      showBackButton: true,
                      actionWidget: model.isBusy
                          ? Container()
                          : IconButton(
                              onPressed: () => model.navigateToCreatePostView(),
                              icon: Icon(FontAwesomeIcons.edit, color: appFontColor(), size: 18),
                            ),
                    ),
                    body: Container(
                      color: appBackgroundColor(),
                      child: SafeArea(
                        child: Container(
                          child: model.isBusy
                              ? Center(child: CustomCircleProgressIndicator(color: appActiveColor(), size: 48))
                              : Column(
                                  children: [
                                    verticalSpaceSmall,
                                    tabBar(model),
                                    verticalSpaceSmall,
                                    body(model),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ));
  }
}
