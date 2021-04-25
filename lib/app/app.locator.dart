// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../services/algolia/algolia_search_service.dart';
import '../services/auth/auth_service.dart';
import '../services/bottom_sheets/custom_bottom_sheet_service.dart';
import '../services/dialogs/custom_dialog_service.dart';
import '../services/dynamic_links/dynamic_link_service.dart';
import '../services/firestore/data/cause_data_service.dart';
import '../services/firestore/data/comment_data_service.dart';
import '../services/firestore/data/notification_data_service.dart';
import '../services/firestore/data/platform_data_service.dart';
import '../services/firestore/data/post_data_service.dart';
import '../services/firestore/data/user_data_service.dart';
import '../services/firestore/utils/firebase_messaging_service.dart';
import '../services/firestore/utils/firebase_storage_service.dart';
import '../services/location/google_places_service.dart';
import '../services/location/location_service.dart';
import '../services/reactive/file_uploader/reactive_file_uploader_service.dart';
import '../services/reactive/user/reactive_user_service.dart';
import '../services/share/share_service.dart';
import '../ui/views/base/app_base_view_model.dart';
import '../ui/views/home/home_nav_view_model.dart';
import '../ui/views/home/tabs/explore/explore_view_model.dart';
import '../ui/views/home/tabs/home/home_view_model.dart';
import '../ui/views/home/tabs/profile/profile_view_model.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ThemeService.getInstance());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => CustomBottomSheetService());
  locator.registerLazySingleton(() => CustomDialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => FirebaseMessagingService());
  locator.registerLazySingleton(() => PlatformDataService());
  locator.registerLazySingleton(() => NotificationDataService());
  locator.registerLazySingleton(() => UserDataService());
  locator.registerLazySingleton(() => PostDataService());
  locator.registerLazySingleton(() => CauseDataService());
  locator.registerLazySingleton(() => CommentDataService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => GooglePlacesService());
  locator.registerLazySingleton(() => AlgoliaSearchService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => ShareService());
  locator.registerLazySingleton(() => ReactiveUserService());
  locator.registerLazySingleton(() => ReactiveFileUploaderService());
  locator.registerSingleton(AppBaseViewModel());
  locator.registerSingleton(HomeNavViewModel());
  locator.registerSingleton(HomeViewModel());
  locator.registerSingleton(ExploreViewModel());
  locator.registerSingleton(ProfileViewModel());
}
