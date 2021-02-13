import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view.dart';
import 'package:go/ui/views/causes/cause/cause_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_posts.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';

class CauseView extends StatefulWidget {
  @override
  _CauseViewState createState() => _CauseViewState();
}

class _CauseViewState extends State<CauseView> with SingleTickerProviderStateMixin {
  TabController _tabController;

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
                child: ListView(
                  
                  scrollDirection: Axis.horizontal,
                    children: 
                    [
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
                    ]
                   
                  ),
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

  Widget tabBar() {
    return GoCauseViewTabBar(
      tabController: _tabController,
    );
  }

  Widget body(CauseViewModel model) {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: TabBarView(
          controller: _tabController,
          children: [
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
              actions: model.cause.actions,
              //descriptors: model.cause.actionDescriptions,
              creatorId: model.cause.creatorID,
              currentUID: model.currentUID,
              name: model.cause.name,
              causeID: model.cause.id,
            ),
            ListPosts(
              refreshingData: model.refreshingPosts,
              refreshData: () => model.refreshPosts(),
              postResults: model.postResults,
              scrollController: model.postsScrollController,
            ),
          ],
        ),
      ),
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
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseViewModel>.reactive(
      onModelReady: (model) => model.initialize(context),
      viewModelBuilder: () => CauseViewModel(),
      builder: (context, model, child) => 
      OrientationBuilder(builder: (context, orientation){
        if (orientation == Orientation.landscape && _tabController.index == 0){

          return body(model);
        } else {
        return Scaffold(
        //appBar: GoAppBar().basicAppBar(title: "Title", showBackButton: true),
        body: Container(
          color: appBackgroundColor(),
          child: SafeArea(
            child: Container(
              child: model.isBusy
                  ? Center(child: CustomCircleProgressIndicator(color: appActiveColor(), size: 48))
                  : Column(
                      children: [
                        head(model),
                        SizedBox(height: 8),
                        tabBar(),
                        body(model),
                      ],
                    ),
            ),
          ),
        ),
      );
        }
      },) 
        
    );
  }
}
