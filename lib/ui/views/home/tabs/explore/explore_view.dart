import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/list_builders/list_users.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';

class ExploreView extends StatefulWidget {
  final GoUser? user;
  ExploreView({this.user});
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Widget noDataFound(String dataType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: "No $dataType Found",
        textAlign: TextAlign.center,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: appFontColorAlt(),
      ),
    );
  }

  Widget head(ExploreViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.navigateToSearchView(),
            enabled: false,
            textEditingController: null,
            onChanged: (String val) {},
            onFieldSubmitted: (String val) {},
          ),
          IconButton(
            onPressed: () => model.navigateToCreateCauseView(),
            icon: Icon(FontAwesomeIcons.plus, color: appIconColor(), size: 20),
          ),
        ],
      ),
    );
  }

  Widget body(ExploreViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        model.causeResults.isEmpty && !model.refreshingCauses
            ? noDataFound("Causes")
            : ListCauses(
                refreshData: model.refreshCauses,
                causesResults: model.causeResults,
                pageStorageKey: PageStorageKey('cause-results'),
                scrollController: model.causeScrollController,
              ),
        model.userResults.isEmpty && !model.refreshingUsers
            ? noDataFound("Users")
            : ListUsers(
                refreshData: model.refreshUsers,
                userResults: model.userResults,
                pageStorageKey: PageStorageKey('user-results'),
                scrollController: model.userScrollController,
              ),
      ],
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
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => locator<ExploreViewModel>(),
      builder: (context, model, child) => Container(
        height: screenHeight(context),
        color: appBackgroundColor(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                head(model),
                verticalSpaceSmall,
                tabBar(),
                verticalSpaceSmall,
                Expanded(
                  child: body(model),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
