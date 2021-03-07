import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/search/all_search_results/all_search_results_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/list_builders/list_users.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';

import 'admins_search_results_view_model.dart';

class AdminSearchResultsView extends StatefulWidget {
  final String searchTerm;
  AdminSearchResultsView({this.searchTerm});
  @override
  _AdminSearchResultsViewState createState() => _AdminSearchResultsViewState();
}

class _AdminSearchResultsViewState extends State<AdminSearchResultsView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget noResultsFound() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: "No Results for \"${widget.searchTerm}\"",
        textAlign: TextAlign.center,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: appFontColorAlt(),
      ),
    );
  }

  Widget head(AdminSearchResultsViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.navigateToPreviousPage(),
            enabled: false,
            textEditingController: model.searchTextController,
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => model.navigateToPreviousPage(),
            child: CustomText(
              text: "Cancel",
              textAlign: TextAlign.right,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: appTextButtonColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget body(AdminSearchResultsViewModel model) {
    return TabBarView(
      controller: _tabController,
      children: [
        model.causeResults.isNotEmpty
            ? ListCauses(
                refreshData: model.refreshCauses,
                causesResults: model.causeResults,
                pageStorageKey: PageStorageKey('cause-results'),
                scrollController: model.causeScrollController,
              )
            : noResultsFound(),
        model.userResults.isNotEmpty
            ? ListUsers(
                refreshData: model.refreshUsers,
                userResults: model.userResults,
                pageStorageKey: PageStorageKey('user-results'),
                scrollController: model.userScrollController,
              )
            : noResultsFound(),
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
    return ViewModelBuilder<AdminSearchResultsViewModel>.reactive(
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(context, widget.searchTerm),
      viewModelBuilder: () => AdminSearchResultsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
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
                  model.isBusy ? CustomLinearProgressIndicator(color: appActiveColor()) : Container(),
                  SizedBox(height: 8),
                  Expanded(
                    child: body(model),
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
