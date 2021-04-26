import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/enums/init_error_status.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view.dart';
import 'package:go/ui/views/home/tabs/feed/feed_view.dart';
import 'package:go/ui/views/home/tabs/home/home_view.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/navigation/nav_bar/custom_nav_bar.dart';
import 'package:go/ui/widgets/navigation/nav_bar/custom_nav_bar_item.dart';
import 'package:stacked/stacked.dart';

import 'app_base_view_model.dart';
import 'init_error_views/network_error/network_error_view.dart';

class AppBaseView extends StatelessWidget {
  Widget getViewForIndex(int index, AppBaseViewModel model) {
    switch (index) {
      case 0:
        return HomeView(
          user: model.user,
          navigateToExplorePage: () => model.setNavBarIndex(1),
        );
      case 1:
        return ExploreView(user: model.user);
      case 2:
        return ProfileView(user: model.user);
      case 3:
        return FeedView(
          user: model.user,
          navigateToExplorePage: () => model.setNavBarIndex(1),
        );
      default:
        return HomeView(
          user: model.user,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBaseViewModel>.reactive(
      onModelReady: (model) {
        if (!model.initialized) {
          model.initialize();
        }
      },
      viewModelBuilder: () => locator<AppBaseViewModel>(),
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Container(
                color: appBackgroundColor(),
                child: Center(
                  child: CustomCircleProgressIndicator(
                    color: appActiveColor(),
                    size: 32,
                  ),
                ),
              )
            : model.initErrorStatus == InitErrorStatus.network
                ? NetworkErrorView(
                    tryAgainAction: () => model.initialize(),
                  )
                : getViewForIndex(model.navBarIndex, model),
        bottomNavigationBar: CustomNavBar(
          navBarItems: [
            CustomNavBarItem(
              onTap: () => model.setNavBarIndex(0),
              iconData: FontAwesomeIcons.home,
              isActive: model.navBarIndex == 0 ? true : false,
            ),
            CustomNavBarItem(
              onTap: () => model.setNavBarIndex(1),
              iconData: FontAwesomeIcons.search,
              isActive: model.navBarIndex == 1 ? true : false,
            ),
            CustomNavBarItem(
              onTap: () => model.setNavBarIndex(2),
              iconData: FontAwesomeIcons.user,
              isActive: model.navBarIndex == 2 ? true : false,
            ),
            CustomNavBarItem(
              onTap: () => model.setNavBarIndex(3),
              iconData: FontAwesomeIcons.envelope,
              isActive: model.navBarIndex == 3 ? true : false,
            ),
          ],
        ),
      ),
    );
  }
}
