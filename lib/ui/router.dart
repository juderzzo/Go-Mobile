import 'package:flutter/material.dart';
import 'package:go/routes/route_names.dart';
import 'package:go/ui/pages/auth_pages/signin_page.dart';
import 'package:go/ui/pages/auth_pages/signup_page.dart';
import 'package:go/ui/pages/home_pages/home_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignInPage(),
      );
    case SignUpPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpPage(),
      );
    case HomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
