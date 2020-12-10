import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/page_models/home_page_models/home_page_model.dart';
import 'package:go/ui/pages/home_pages/screens/explore_screen.dart';
import 'package:go/ui/pages/home_pages/screens/home_screen.dart';
import 'package:go/ui/pages/home_pages/screens/profile_screen.dart';
import 'package:go/ui/widgets/navigation/nav_bar/go_nav_bar.dart';
import 'package:go/ui/widgets/navigation/nav_bar/go_nav_bar_item.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class HomePage extends StatelessWidget {
  final List<Widget> screens = [
    HomeScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomePageModel>.withConsumer(
      viewModelBuilder: () => HomePageModel(),
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
