// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models/go_cause_model.dart';
import '../models/go_user_model.dart';
import '../ui/views/auth/forgot_password/forgot.dart';
import '../ui/views/auth/sign_in/sign_in_view.dart';
import '../ui/views/auth/sign_up/sign_up_view.dart';
import '../ui/views/causes/cause/cause_detail_views/admin/adminview.dart';
import '../ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import '../ui/views/causes/cause/cause_view.dart';
import '../ui/views/causes/cause/edit_cause/edit_cause_view.dart';
import '../ui/views/causes/create_cause/create_cause_view.dart';
import '../ui/views/home/home_nav_view.dart';
import '../ui/views/home/tabs/feed/feed_view.dart';
import '../ui/views/home/tabs/profile/edit_profile/edit_profile_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/onboarding/onboarding_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/search/admins_search/admins_search_results/admins_search_results_view.dart';
import '../ui/views/search/admins_search/admins_search_view.dart';
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
  static const String FeedViewRoute = '/feed-view';
  static const String CauseViewRoute = '/cause-view';
  static const String EditCauseViewRoute = '/edit-cause-view';
  static const String CreateCauseViewRoute = '/create-cause-view';
  static const String EditCheckListView = '/edit-check-list-view';
  static const String AdminView = '/admin-view';
  static const String ForumPostViewRoute = '/forum-post-view';
  static const String CreateForumPostViewRoute = '/create-forum-post-view';
  static const String UserViewRoute = '/user-view';
  static const String NotificationsViewRoute = '/notifications-view';
  static const String SearchViewRoute = '/search-view';
  static const String AllSearchResultsViewRoute = '/all-search-results-view';
  static const String AdminSearchViewRoute = '/admin-search-view';
  static const String AdminSearchResultsViewRoute =
      '/admin-search-results-view';
  static const String SettingsViewRoute = '/settings-view';
  static const String EditProfileViewRoute = '/edit-profile-view';
  static const all = <String>{
    RootViewRoute,
    SignUpViewRoute,
    SignInViewRoute,
    ForgotViewRoute,
    OnboardingViewRoute,
    HomeNavViewRoute,
    FeedViewRoute,
    CauseViewRoute,
    EditCauseViewRoute,
    CreateCauseViewRoute,
    EditCheckListView,
    AdminView,
    ForumPostViewRoute,
    CreateForumPostViewRoute,
    UserViewRoute,
    NotificationsViewRoute,
    SearchViewRoute,
    AllSearchResultsViewRoute,
    AdminSearchViewRoute,
    AdminSearchResultsViewRoute,
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
    RouteDef(Routes.FeedViewRoute, page: FeedView),
    RouteDef(Routes.CauseViewRoute, page: CauseView),
    RouteDef(Routes.EditCauseViewRoute, page: EditCauseView),
    RouteDef(Routes.CreateCauseViewRoute, page: CreateCauseView),
    RouteDef(Routes.EditCheckListView, page: EditCheckListView),
    RouteDef(Routes.AdminView, page: AdminView),
    RouteDef(Routes.ForumPostViewRoute, page: ForumPostView),
    RouteDef(Routes.CreateForumPostViewRoute, page: CreateForumPostView),
    RouteDef(Routes.UserViewRoute, page: UserView),
    RouteDef(Routes.NotificationsViewRoute, page: NotificationsView),
    RouteDef(Routes.SearchViewRoute, page: SearchView),
    RouteDef(Routes.AllSearchResultsViewRoute, page: AllSearchResultsView),
    RouteDef(Routes.AdminSearchViewRoute, page: AdminSearchView),
    RouteDef(Routes.AdminSearchResultsViewRoute, page: AdminSearchResultsView),
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
    FeedView: (data) {
      final args = data.getArgs<FeedViewArguments>(
        orElse: () => FeedViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FeedView(
          user: args.user,
          navigateToExplorePage: args.navigateToExplorePage,
        ),
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
          monetized: args.monetized,
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
    EditCheckListView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditCheckListView(),
        settings: data,
      );
    },
    AdminView: (data) {
      final args = data.getArgs<AdminViewArguments>(
        orElse: () => AdminViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminView(
          cause: args.cause,
          admin: args.admin,
        ),
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
    AdminSearchView: (data) {
      final args = data.getArgs<AdminSearchViewArguments>(
        orElse: () => AdminSearchViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AdminSearchView(
          addAdmin: args.addAdmin,
          cause: args.cause,
        ),
        settings: data,
      );
    },
    AdminSearchResultsView: (data) {
      final args = data.getArgs<AdminSearchResultsViewArguments>(
        orElse: () => AdminSearchResultsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            AdminSearchResultsView(searchTerm: args.searchTerm),
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

/// FeedView arguments holder class
class FeedViewArguments {
  final GoUser user;
  final void Function() navigateToExplorePage;
  FeedViewArguments({this.user, this.navigateToExplorePage});
}

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
  final bool monetized;
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
      this.videoLink,
      this.monetized});
}

/// AdminView arguments holder class
class AdminViewArguments {
  final GoCause cause;
  final bool admin;
  AdminViewArguments({this.cause, this.admin});
}

/// AllSearchResultsView arguments holder class
class AllSearchResultsViewArguments {
  final String searchTerm;
  AllSearchResultsViewArguments({this.searchTerm});
}

/// AdminSearchView arguments holder class
class AdminSearchViewArguments {
  final Function addAdmin;
  final GoCause cause;
  AdminSearchViewArguments({this.addAdmin, this.cause});
}

/// AdminSearchResultsView arguments holder class
class AdminSearchResultsViewArguments {
  final String searchTerm;
  AdminSearchResultsViewArguments({this.searchTerm});
}
