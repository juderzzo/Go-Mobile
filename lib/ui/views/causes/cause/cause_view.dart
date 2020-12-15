import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_view.dart';
import 'package:go/ui/views/causes/cause/cause_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
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
                onPressed: () => model.popPage(),
                icon: Icon(FontAwesomeIcons.angleLeft, color: Colors.black, size: 24),
              ),
              Text(
                model.cause.name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ],
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
            AboutView(
              cause: model.cause,
              images: model.images,
              creatorUsername: "@${model.causeCreator.username}",
              creatorProfilePicURL: model.causeCreator.profilePicURL,
              viewCreator: null,
              isFollowing: false,
            ),
            CheckListView(
              actions: model.cause.actions,
            ),
            ForumView(),
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
      builder: (context, model, child) => Scaffold(
        //appBar: GoAppBar().basicAppBar(title: "Title", showBackButton: true),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              child: model.isBusy
                  ? Center(child: CustomCircleProgressIndicator(color: Colors.black38, size: 48))
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
      ),
    );
  }
}
