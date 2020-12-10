import 'package:flutter/material.dart';
import 'package:go/routes/route_names.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  pop() {
    return _navigationKey.currentState.pop();
  }

  returnToRootPage() {
    return _navigationKey.currentState.pushNamedAndRemoveUntil(RootPageRoute, (route) => false);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> replaceWith(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushReplacementNamed(routeName, arguments: arguments);
  }
}
