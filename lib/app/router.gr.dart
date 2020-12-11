// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/auth/sign_in/sign_in_view.dart';
import '../ui/views/auth/sign_up/sign_up_view.dart';
import '../ui/views/home/home_nav_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/settings/settings_view.dart';

class Routes {
  static const String RootViewRoute = '/';
  static const String SignUpViewRoute = '/sign-up-view';
  static const String SignInViewRoute = '/sign-in-view';
  static const String HomeNavViewRoute = '/home-nav-view';
  static const String SettingsViewRoute = '/settings-view';
  static const all = <String>{
    RootViewRoute,
    SignUpViewRoute,
    SignInViewRoute,
    HomeNavViewRoute,
    SettingsViewRoute,
  };
}

class GoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.RootViewRoute, page: RootView),
    RouteDef(Routes.SignUpViewRoute, page: SignUpView),
    RouteDef(Routes.SignInViewRoute, page: SignInView),
    RouteDef(Routes.HomeNavViewRoute, page: HomeNavView),
    RouteDef(Routes.SettingsViewRoute, page: SettingsView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    RootView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RootView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpView(),
        settings: data,
      );
    },
    SignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInView(),
        settings: data,
      );
    },
    HomeNavView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeNavView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsView(),
        settings: data,
      );
    },
  };
}
