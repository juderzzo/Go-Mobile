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
import 'package:go/services/reactive/file_uploader/reactive_file_uploader_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:go/ui/views/auth/forgot_password/forgot.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view.dart';
import 'package:go/ui/views/auth/sign_up/sign_up_view.dart';
import 'package:go/ui/views/base/app_base_view.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import 'package:go/ui/views/causes/cause/cause_view.dart';
import 'package:go/ui/views/home/home_nav_view_model.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/views/notifications/notifications_view.dart';
import 'package:go/ui/views/onboarding/onboarding_view.dart';
import 'package:go/ui/views/root/root_view.dart';
import 'package:go/ui/views/settings/settings_view.dart';
import 'package:go/ui/views/user/user_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

@StackedApp(
  routes: [
    //ROOT & BASE
    CustomRoute(
      page: RootView,
      name: "RootViewRoute",
      path: "/root",
      //transitionsBuilder: ,
      durationInMilliseconds: 0,
    ),
    CustomRoute(
      page: AppBaseView,
      name: "AppBaseViewRoute",
      path: "/",
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

    //USERS
    CustomRoute(
      page: UserView,
      name: "UserViewRoute",
      path: "/users/:id",
      //transitionsBuilder: ,
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

    //REACTIVE LAZY SINGLETONS
    LazySingleton(classType: ReactiveUserService),
    LazySingleton(classType: ReactiveFileUploaderService),

    //SINGLETONS
    Singleton(classType: AppBaseViewModel),
    Singleton(classType: HomeNavViewModel),
    Singleton(classType: HomeViewModel),
    Singleton(classType: ExploreViewModel),
    Singleton(classType: ProfileViewModel),
  ],
)
class AppSetup {
  /// no purpose outside of annotation
}
