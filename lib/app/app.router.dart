// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/auth/forgot_password/forgot.dart';
import '../ui/views/auth/sign_in/sign_in_view.dart';
import '../ui/views/auth/sign_up/sign_up_view.dart';
import '../ui/views/base/app_base_view.dart';
import '../ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view.dart';
import '../ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import '../ui/views/causes/cause/cause_view.dart';
import '../ui/views/causes/create_cause/create_cause_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/onboarding/onboarding_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/search/all_search_results/all_search_results_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/user/edit_profile/edit_profile_view.dart';
import '../ui/views/user/profile/user_profile_view.dart';

class Routes {
  static const String RootViewRoute = '/';
  static const String AppBaseViewRoute = '/home';
  static const String SignInViewRoute = '/sign-in';
  static const String SignUpViewRoute = '/sign-up';
  static const String ForgotViewRoute = '/forgot-auth';
  static const String OnboardingViewRoute = '/onboard';
  static const String _CauseViewRoute = '/causes/:id';
  static String CauseViewRoute({@required dynamic id}) => '/causes/$id';
  static const String _CreateCauseViewRoute = '/create_cause/:id';
  static String CreateCauseViewRoute({@required dynamic id}) =>
      '/create_cause/$id';
  static const String _EditCheckListViewRoute = '/causes/checklist/edit/:id';
  static String EditCheckListViewRoute({@required dynamic id}) =>
      '/causes/checklist/edit/$id';
  static const String _ForumPostViewRoute = '/forums/:id';
  static String ForumPostViewRoute({@required dynamic id}) => '/forums/$id';
  static const String _CreateForumPostViewRoute = '/create_post/:causeID/:id';
  static String CreateForumPostViewRoute(
          {@required dynamic causeID, @required dynamic id}) =>
      '/create_post/$causeID/$id';
  static const String _UserProfileViewRoute = '/users/:id';
  static String UserProfileViewRoute({@required dynamic id}) => '/users/$id';
  static const String EditProfileViewRoute = '/edit_profile';
  static const String SearchViewRoute = '/search';
  static const String _AllSearchResultsViewRoute = '/all_results/:term';
  static String AllSearchResultsViewRoute({@required dynamic term}) =>
      '/all_results/$term';
  static const String SettingsViewRoute = '/settings';
  static const String NotificationsViewRoute = '/notifications';
  static const all = <String>{
    RootViewRoute,
    AppBaseViewRoute,
    SignInViewRoute,
    SignUpViewRoute,
    ForgotViewRoute,
    OnboardingViewRoute,
    _CauseViewRoute,
    _CreateCauseViewRoute,
    _EditCheckListViewRoute,
    _ForumPostViewRoute,
    _CreateForumPostViewRoute,
    _UserProfileViewRoute,
    EditProfileViewRoute,
    SearchViewRoute,
    _AllSearchResultsViewRoute,
    SettingsViewRoute,
    NotificationsViewRoute,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.RootViewRoute, page: RootView),
    RouteDef(Routes.AppBaseViewRoute, page: AppBaseView),
    RouteDef(Routes.SignInViewRoute, page: SignInView),
    RouteDef(Routes.SignUpViewRoute, page: SignUpView),
    RouteDef(Routes.ForgotViewRoute, page: ForgotView),
    RouteDef(Routes.OnboardingViewRoute, page: OnboardingView),
    RouteDef(Routes._CauseViewRoute, page: CauseView),
    RouteDef(Routes._CreateCauseViewRoute, page: CreateCauseView),
    RouteDef(Routes._EditCheckListViewRoute, page: EditCheckListView),
    RouteDef(Routes._ForumPostViewRoute, page: ForumPostView),
    RouteDef(Routes._CreateForumPostViewRoute, page: CreateForumPostView),
    RouteDef(Routes._UserProfileViewRoute, page: UserProfileView),
    RouteDef(Routes.EditProfileViewRoute, page: EditProfileView),
    RouteDef(Routes.SearchViewRoute, page: SearchView),
    RouteDef(Routes._AllSearchResultsViewRoute, page: AllSearchResultsView),
    RouteDef(Routes.SettingsViewRoute, page: SettingsView),
    RouteDef(Routes.NotificationsViewRoute, page: NotificationsView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    RootView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => RootView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    AppBaseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => AppBaseView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SignInView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SignInView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SignUpView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    ForgotView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => ForgotView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    OnboardingView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CauseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CauseView(id: data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreateCauseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateCauseView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EditCheckListView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditCheckListView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    ForumPostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ForumPostView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    CreateForumPostView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateForumPostView(
          causeID: data.pathParams['causeID'].value,
          id: data.pathParams['id'].value,
        ),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    UserProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            UserProfileView(data.pathParams['id'].value),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    EditProfileView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditProfileView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SearchView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SearchView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    AllSearchResultsView: (data) {
      var args = data.getArgs<AllSearchResultsViewArguments>(
        orElse: () => AllSearchResultsViewArguments(),
      );
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AllSearchResultsView(searchTerm: args.searchTerm),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    SettingsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
    NotificationsView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NotificationsView(),
        settings: data,
        transitionDuration: const Duration(milliseconds: 0),
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AllSearchResultsView arguments holder class
class AllSearchResultsViewArguments {
  final String? searchTerm;
  AllSearchResultsViewArguments({this.searchTerm});
}
