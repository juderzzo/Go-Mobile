// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/auth/forgot_password/forgot.dart';
import '../ui/views/auth/sign_in/sign_in_view.dart';
import '../ui/views/auth/sign_up/sign_up_view.dart';
import '../ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import '../ui/views/causes/cause/cause_view.dart';
import '../ui/views/causes/cause/edit_cause/edit_cause_view.dart';
import '../ui/views/causes/create_cause/create_cause_view.dart';
import '../ui/views/home/home_nav_view.dart';
import '../ui/views/home/tabs/profile/edit_profile/edit_profile_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/onboarding/onboarding_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/search/all_search_results/all_search_results_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/user/user_view.dart';

class Routes {
  static const String RootViewRoute = '/';
  static const String SignUpViewRoute = '/sign-up-view';
  static const String SignInViewRoute = '/sign-in-view';
  static const String ForgotViewRoute = '/forgot-view';
  static const String OnboardingViewRoute = '/onboarding-view';
  static const String HomeNavViewRoute = '/home-nav-view';
  static const String CauseViewRoute = '/cause-view';
  static const String EditCauseViewRoute = '/edit-cause-view';
  static const String CreateCauseViewRoute = '/create-cause-view';
  static const String EditChecklistView = '/edit-checklist-view';
  static const String ForumPostViewRoute = '/forum-post-view';
  static const String CreateForumPostViewRoute = '/create-forum-post-view';
  static const String UserViewRoute = '/user-view';
  static const String NotificationsViewRoute = '/notifications-view';
  static const String SearchViewRoute = '/search-view';
  static const String AllSearchResultsViewRoute = '/all-search-results-view';
  static const String SettingsViewRoute = '/settings-view';
  static const String EditProfileViewRoute = '/edit-profile-view';
  static const all = <String>{
    RootViewRoute,
    SignUpViewRoute,
    SignInViewRoute,
    ForgotViewRoute,
    OnboardingViewRoute,
    HomeNavViewRoute,
    CauseViewRoute,
    EditCauseViewRoute,
    CreateCauseViewRoute,
    EditChecklistView,
    ForumPostViewRoute,
    CreateForumPostViewRoute,
    UserViewRoute,
    NotificationsViewRoute,
    SearchViewRoute,
    AllSearchResultsViewRoute,
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
    RouteDef(Routes.ForgotViewRoute, page: ForgotView),
    RouteDef(Routes.OnboardingViewRoute, page: OnboardingView),
    RouteDef(Routes.HomeNavViewRoute, page: HomeNavView),
    RouteDef(Routes.CauseViewRoute, page: CauseView),
    RouteDef(Routes.EditCauseViewRoute, page: EditCauseView),
    RouteDef(Routes.CreateCauseViewRoute, page: CreateCauseView),
    RouteDef(Routes.EditChecklistView, page: EditChecklistView),
    RouteDef(Routes.ForumPostViewRoute, page: ForumPostView),
    RouteDef(Routes.CreateForumPostViewRoute, page: CreateForumPostView),
    RouteDef(Routes.UserViewRoute, page: UserView),
    RouteDef(Routes.NotificationsViewRoute, page: NotificationsView),
    RouteDef(Routes.SearchViewRoute, page: SearchView),
    RouteDef(Routes.AllSearchResultsViewRoute, page: AllSearchResultsView),
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
    ForgotView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgotView(),
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
    EditCauseView: (data) {
      final args = data.getArgs<EditCauseViewArguments>(
        orElse: () => EditCauseViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditCauseView(
          causeID: args.causeID,
          name: args.name,
          goals: args.goals,
          why: args.why,
          who: args.who,
          resources: args.resources,
          charity: args.charity,
          img1: args.img1,
          img2: args.img2,
          img3: args.img3,
          videoLink: args.videoLink,
        ),
        settings: data,
      );
    },
    CreateCauseView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateCauseView(),
        settings: data,
      );
    },
    EditChecklistView: (data) {
      final args = data.getArgs<EditChecklistViewArguments>(
        orElse: () => EditChecklistViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditChecklistView(arguments: args.arguments),
        settings: data,
      );
    },
    ForumPostView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForumPostView(),
        settings: data,
      );
    },
    CreateForumPostView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateForumPostView(),
        settings: data,
      );
    },
    UserView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => UserView(),
        settings: data,
      );
    },
    NotificationsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotificationsView(),
        settings: data,
      );
    },
    SearchView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchView(),
        settings: data,
      );
    },
    AllSearchResultsView: (data) {
      final args = data.getArgs<AllSearchResultsViewArguments>(
        orElse: () => AllSearchResultsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AllSearchResultsView(searchTerm: args.searchTerm),
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

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// EditCauseView arguments holder class
class EditCauseViewArguments {
  final String causeID;
  final String name;
  final String goals;
  final String why;
  final String who;
  final String resources;
  final String charity;
  final dynamic img1;
  final dynamic img2;
  final dynamic img3;
  final String videoLink;
  EditCauseViewArguments(
      {this.causeID,
      this.name,
      this.goals,
      this.why,
      this.who,
      this.resources,
      this.charity,
      this.img1,
      this.img2,
      this.img3,
      this.videoLink});
}

/// EditChecklistView arguments holder class
class EditChecklistViewArguments {
  final List<dynamic> arguments;
  EditChecklistViewArguments({this.arguments});
}

/// AllSearchResultsView arguments holder class
class AllSearchResultsViewArguments {
  final String searchTerm;
  AllSearchResultsViewArguments({this.searchTerm});
}
