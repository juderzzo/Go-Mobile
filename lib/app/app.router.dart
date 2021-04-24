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
import '../ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import '../ui/views/causes/cause/cause_view.dart';
import '../ui/views/notifications/notifications_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/user/user_view.dart';

class Routes {
  static const String RootViewRoute = '/root';
  static const String AppBaseViewRoute = '/';
  static const String SignInViewRoute = '/sign-in';
  static const String SignUpViewRoute = '/sign-up';
  static const String ForgotViewRoute = '/forgot-auth';
  static const String _CauseViewRoute = '/causes/:id';
  static String CauseViewRoute({required dynamic id}) => '/causes/$id';
  static const String _EditCheckListViewRoute = '/causes/checklist/edit/:id';
  static String EditCheckListViewRoute({required dynamic id}) =>
      '/causes/checklist/edit/$id';
  static const String _ForumPostViewRoute = '/forums/:id';
  static String ForumPostViewRoute({required dynamic id}) => '/forums/$id';
  static const String _UserViewRoute = '/users/:id';
  static String UserViewRoute({required dynamic id}) => '/users/$id';
  static const String SettingsViewRoute = '/settings';
  static const String NotificationsViewRoute = '/notifications';
  static const all = <String>{
    RootViewRoute,
    AppBaseViewRoute,
    SignInViewRoute,
    SignUpViewRoute,
    ForgotViewRoute,
    _CauseViewRoute,
    _EditCheckListViewRoute,
    _ForumPostViewRoute,
    _UserViewRoute,
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
    RouteDef(Routes._CauseViewRoute, page: CauseView),
    RouteDef(Routes._EditCheckListViewRoute, page: EditCheckListView),
    RouteDef(Routes._ForumPostViewRoute, page: ForumPostView),
    RouteDef(Routes._UserViewRoute, page: UserView),
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
    CauseView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => CauseView(),
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
    UserView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) => UserView(),
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
