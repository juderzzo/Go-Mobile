import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/widgets/list_builders/causes/explore/list_explore_causes.dart';
import 'package:go/ui/widgets/list_builders/users/explore/list_explore_users.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ExploreView extends StatelessWidget {
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
            child: Column(
              children: [
                _ExploreViewHead(),
                verticalSpaceSmall,
                _ExploreViewBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreViewHead extends HookViewModelWidget<ExploreViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ExploreViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: () => model.customNavigationService.navigateToSearchView(),
            enabled: false,
            textEditingController: null,
            onChanged: (String val) {},
            onFieldSubmitted: (String val) {},
          ),
          IconButton(
            onPressed: () => model.customBottomSheetService.showAddCauseBottomSheet(),
            icon: Icon(FontAwesomeIcons.plus, color: appIconColor(), size: 20),
          ),
        ],
      ),
    );
  }
}

class _ExploreViewBody extends HookViewModelWidget<ExploreViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ExploreViewModel model) {
    final _tabController = useTabController(initialLength: 2);
    return Expanded(
      child: Container(
        child: Column(
          children: [
            GoExplorePageTabBar(
              tabController: _tabController,
            ),
            verticalSpaceSmall,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListExploreCauses(),
                  ListExploreUsers(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
