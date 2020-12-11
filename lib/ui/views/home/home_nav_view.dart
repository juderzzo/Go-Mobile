import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/home/home_nav_view_model.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view.dart';
import 'package:go/ui/views/home/tabs/home/home_view.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view.dart';
import 'package:go/ui/widgets/navigation/nav_bar/go_nav_bar.dart';
import 'package:go/ui/widgets/navigation/nav_bar/go_nav_bar_item.dart';
import 'package:stacked/stacked.dart';

class HomeNavView extends StatelessWidget {
  final List<Widget> screens = [
    HomeView(),
    ExploreView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeNavViewModel>.reactive(
      viewModelBuilder: () => HomeNavViewModel(),
      builder: (context, model, child) => Scaffold(
        body: screens[model.navBarIndex],
        bottomNavigationBar: GoNavBar(
          navBarItems: [
            GoNavBarItem(
              onTap: () => model.setNavBarIndex(0),
              label: "Home",
              iconData: FontAwesomeIcons.home,
              isActive: model.navBarIndex == 0 ? true : false,
            ),
            GoNavBarItem(
              onTap: () => model.setNavBarIndex(1),
              label: "Explore",
              iconData: FontAwesomeIcons.compass,
              isActive: model.navBarIndex == 1 ? true : false,
            ),
            GoNavBarItem(
              onTap: () => model.setNavBarIndex(2),
              label: "Profile",
              iconData: FontAwesomeIcons.user,
              isActive: model.navBarIndex == 2 ? true : false,
            ),
          ],
        ),
      ),
    );
  }
}
