import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';

class ExploreView extends StatefulWidget {
  final GoUser user;
  ExploreView({this.user});
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head(ExploreViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.navigateToSearchView(),
            enabled: false,
            textEditingController: null,
          ),
          IconButton(
            onPressed: () => model.navigateToCreateCauseView(),
            icon: Icon(FontAwesomeIcons.plus, color: appIconColor(), size: 20),
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return GoExplorePageTabBar(
      tabController: _tabController,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => locator<ExploreViewModel>(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                head(model),
                SizedBox(height: 8),
                tabBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
