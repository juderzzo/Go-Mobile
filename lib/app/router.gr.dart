// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/auth/sign_in/sign_in_view.dart';
import '../ui/views/auth/sign_up/sign_up_view.dart';
import '../ui/views/causes/cause/cause_view.dart';
import '../ui/views/causes/create_cause/create_cause_view.dart';
import '../ui/views/home/home_nav_view.dart';
import '../ui/views/home/tabs/profile/edit_profile/edit_profile_view.dart';
import '../ui/views/onboarding/onboarding_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/settings/settings_view.dart';

class Routes {
  static const String RootViewRoute = '/';
  static const String SignUpViewRoute = '/sign-up-view';
  static const String SignInViewRoute = '/sign-in-view';
  static const String OnboardingViewRoute = '/onboarding-view';
  static const String HomeNavViewRoute = '/home-nav-view';
  static const String CauseViewRoute = '/cause-view';
  static const String CreateCauseViewRoute = '/create-cause-view';
  static const String SearchViewRoute = '/search-view';
  static const String SettingsViewRoute = '/settings-view';
  static const String EditProfileViewRoute = '/edit-profile-view';
  static const all = <String>{
    RootViewRoute,
    SignUpViewRoute,
    SignInViewRoute,
    OnboardingViewRoute,
    HomeNavViewRoute,
    CauseViewRoute,
    CreateCauseViewRoute,
    SearchViewRoute,
    SettingsViewRoute,
    EditProfileViewRoute,
  };
}

class GoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.RootViewRoute, page: RootView),
    RouteDef(Routes.SignUpViewRoute, page: SignUpView),
    RouteDef(Routes.SignInViewRoute, page: SignInView),
    RouteDef(Routes.OnboardingViewRoute, page: OnboardingView),
    RouteDef(Routes.HomeNavViewRoute, page: HomeNavView),
    RouteDef(Routes.CauseViewRoute, page: CauseView),
    RouteDef(Routes.CreateCauseViewRoute, page: CreateCauseView),
    RouteDef(Routes.SearchViewRoute, page: SearchView),
    RouteDef(Routes.SettingsViewRoute, page: SettingsView),
    RouteDef(Routes.EditProfileViewRoute, page: EditProfileView),
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
    OnboardingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => OnboardingView(),
        settings: data,
      );
    },
    HomeNavView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeNavView(),
        settings: data,
      );
    },
    CauseView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CauseView(),
        settings: data,
      );
    },
    CreateCauseView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateCauseView(),
        settings: data,
      );
    },
    SearchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsView(),
        settings: data,
      );
    },
    EditProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditProfileView(),
        settings: data,
      );
    },
  };
}
