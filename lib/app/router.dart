import 'package:auto_route/auto_route_annotations.dart';
import 'package:go/ui/views/auth/forgot_password/forgot.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view.dart';
import 'package:go/ui/views/auth/sign_up/sign_up_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import 'package:go/ui/views/causes/cause/cause_view.dart';
import 'package:go/ui/views/causes/cause/edit_cause/edit_cause_view.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view.dart';
import 'package:go/ui/views/home/home_nav_view.dart';
import 'package:go/ui/views/home/tabs/profile/edit_profile/edit_profile_view.dart';
import 'package:go/ui/views/notifications/notifications_view.dart';
import 'package:go/ui/views/onboarding/onboarding_view.dart';
import 'package:go/ui/views/root/root_view.dart';
import 'package:go/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:go/ui/views/settings/settings_view.dart';
import 'package:go/ui/views/user/user_view.dart';

///RUN "flutter pub run build_runner build --delete-conflicting-outputs" in Project Terminal to Generate Routes
@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: RootView, initial: true, name: "RootViewRoute"),

    //AUTHENTICATION
    MaterialRoute(page: SignUpView, name: "SignUpViewRoute"),
    MaterialRoute(page: SignInView, name: "SignInViewRoute"),
    MaterialRoute(page: ForgotView, name: "ForgotViewRoute"),

    //ONBOARDING
    MaterialRoute(page: OnboardingView, name: "OnboardingViewRoute"),

    //HOME
    MaterialRoute(page: HomeNavView, name: "HomeNavViewRoute"),

    //CAUSES
    MaterialRoute(page: CauseView, name: "CauseViewRoute"),
    MaterialRoute(page: EditCauseView, name: "EditCauseViewRoute"),
    MaterialRoute(page: CreateCauseView, name: "CreateCauseViewRoute"),
    MaterialRoute(page: EditCheckListView, name: "EditCheckListView"),

    //FORUM POSTS
    MaterialRoute(page: ForumPostView, name: "ForumPostViewRoute"),
    MaterialRoute(page: CreateForumPostView, name: "CreateForumPostViewRoute"),

    //USERS
    MaterialRoute(page: UserView, name: "UserViewRoute"),

    //NOTIFICATIONS
    MaterialRoute(page: NotificationsView, name: "NotificationsViewRoute"),

    //SEARCH
    MaterialRoute(page: SearchView, name: "SearchViewRoute"),
    MaterialRoute(page: AllSearchResultsView, name: "AllSearchResultsViewRoute"),

    //SETTINGS
    MaterialRoute(page: SettingsView, name: "SettingsViewRoute"),
    MaterialRoute(page: EditProfileView, name: "EditProfileViewRoute"),
  ],
)
class $GoRouter {}
