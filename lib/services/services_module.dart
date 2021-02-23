import 'package:go/services/algolia/algolia_search_service.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firebase_messaging/firebase_messaging_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/services/firestore/comment_data_service.dart';
import 'package:go/services/firestore/notification_data_service.dart';
import 'package:go/services/firestore/post_data_service.dart';
import 'package:go/services/share/share_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'dynamic_links/dynamic_link_service.dart';
import 'firestore/user_data_service.dart';

///RUN "flutter pub run build_runner build --delete-conflicting-outputs" in Project Terminal to Generate Service Modules

@module
abstract class ServicesModule {
  @lazySingleton
  ThemeService get themeService => ThemeService.getInstance();
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  BottomSheetService get bottomSheetService;
  @lazySingleton
  SnackbarService get snackBarService;
  @lazySingleton
  AuthService get authService;
  @lazySingleton
  FirebaseMessagingService get firebaseMessagingService;
  @lazySingleton
  NotificationDataService get notificationDataService;
  @lazySingleton
  UserDataService get userDataService;
  @lazySingleton
  CauseDataService get causeDataService;
  @lazySingleton
  PostDataService get postDataService;
  @lazySingleton
  CommentDataService get commentDataService;
  @lazySingleton
  AlgoliaSearchService get algoliaSearchService;
  @lazySingleton
  DynamicLinkService get dynamicLinkService;
  @lazySingleton
  ShareService get shareService;
}
