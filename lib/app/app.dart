import 'package:go/services/algolia/algolia_search_service.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/comment_data_service.dart';
import 'package:go/services/firestore/data/notification_data_service.dart';
import 'package:go/services/firestore/data/platform_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/firestore/utils/firebase_messaging_service.dart';
import 'package:go/services/firestore/utils/firebase_storage_service.dart';
import 'package:go/services/location/google_places_service.dart';
import 'package:go/services/location/location_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/services/permission_handler/permission_handler_service.dart';
import 'package:go/services/reactive/file_uploader/reactive_file_uploader_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/ui/views/auth/forgot_password/forgot.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view.dart';
import 'package:go/ui/views/auth/sign_up/sign_up_view.dart';
import 'package:go/ui/views/base/app_base_view.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import 'package:go/ui/views/causes/cause/cause_view.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/views/home/tabs/feed/feed_view_model.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/views/notifications/notifications_view.dart';
import 'package:go/ui/views/onboarding/onboarding_view.dart';
import 'package:go/ui/views/root/root_view.dart';
import 'package:go/ui/views/search/all_search_results/all_search_results_view.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:go/ui/views/settings/settings_view.dart';
import 'package:go/ui/views/user/edit_profile/edit_profile_view.dart';
import 'package:go/ui/views/user/profile/user_profile_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

@StackedApp(
  routes: [
    //ROOT & BASE
    CustomRoute(
      initial: true,
      page: RootView,
      name: "RootViewRoute",
      path: "/",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: AppBaseView,
      name: "AppBaseViewRoute",
      path: "/home",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //AUTHENTICATION
    CustomRoute(
      page: SignInView,
      name: "SignInViewRoute",
      path: "/sign-in",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: SignUpView,
      name: "SignUpViewRoute",
      path: "/sign-up",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: ForgotView,
      name: "ForgotViewRoute",
      path: "/forgot-auth",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //ONBOARDING
    CustomRoute(
      page: OnboardingView,
      name: "OnboardingViewRoute",
      path: "/onboard",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //CAUSES
    CustomRoute(
      page: CauseView,
      name: "CauseViewRoute",
      path: "/causes/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateCauseView,
      name: "CreateCauseViewRoute",
      path: "/create_cause/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EditCheckListView,
      name: "EditCheckListViewRoute",
      path: "/causes/checklist/edit/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //FORUM POSTS
    CustomRoute(
      page: ForumPostView,
      name: "ForumPostViewRoute",
      path: "/forums/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: CreateForumPostView,
      name: "CreateForumPostViewRoute",
      path: "/create_post/:causeID/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),

    //USERS
    CustomRoute(
      page: UserProfileView,
      name: "UserProfileViewRoute",
      path: "/users/:id",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: EditProfileView,
      name: "EditProfileViewRoute",
      path: "/edit_profile",
      //transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 0,
    ),
    // CustomRoute(
    //   page: UserFollowersView,
    //   name: "UserFollowersViewRoute",
    //   path: "/profile/followers/:id",
    //   //transitionsBuilder: TransitionsBuilders.fadeIn,
    //   durationInMilliseconds: 0,
    // ),
    // CustomRoute(
    //   page: UserFollowingView,
    //   name: "UserFollowingViewRoute",
    //   path: "/profile/following/:id",
    //   //transitionsBuilder: TransitionsBuilders.fadeIn,
    //   durationInMilliseconds: 0,
    // ),

    //SEARCH
    CustomRoute(
      page: SearchView,
      name: "SearchViewRoute",
      path: "/search",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: AllSearchResultsView,
      name: "AllSearchResultsViewRoute",
      path: "/all_results/:term",
      durationInMilliseconds: 0,
    ),

    //SETTINGS & NOTIFICATIONS
    CustomRoute(
      page: SettingsView,
      name: "SettingsViewRoute",
      path: "/settings",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: NotificationsView,
      name: "NotificationsViewRoute",
      path: "/notifications",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
  ],
  dependencies: [
    //LAZY SINGLETONS
    LazySingleton(
      classType: ThemeService,
      resolveUsing: ThemeService.getInstance,
    ),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: CustomBottomSheetService),
    LazySingleton(classType: CustomDialogService),
    LazySingleton(classType: CustomNavigationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: FirebaseStorageService),
    LazySingleton(classType: FirebaseMessagingService),
    LazySingleton(classType: PlatformDataService),
    LazySingleton(classType: NotificationDataService),
    LazySingleton(classType: UserDataService),
    LazySingleton(classType: PostDataService),
    LazySingleton(classType: CauseDataService),
    LazySingleton(classType: CommentDataService),
    LazySingleton(classType: LocationService),
    LazySingleton(classType: GooglePlacesService),
    LazySingleton(classType: AlgoliaSearchService),
    LazySingleton(classType: DynamicLinkService),
    LazySingleton(classType: ShareService),
    LazySingleton(classType: PermissionHandlerService),

    //REACTIVE LAZY SINGLETONS
    LazySingleton(classType: ReactiveUserService),
    LazySingleton(classType: ReactiveFileUploaderService),

    //SINGLETONS
    Singleton(classType: AppBaseViewModel),
    Singleton(classType: HomeViewModel),
    Singleton(classType: ExploreViewModel),
    Singleton(classType: ProfileViewModel),
    Singleton(classType: FeedViewModel),
  ],
)
class AppSetup {
  /// no purpose outside of annotation
}
