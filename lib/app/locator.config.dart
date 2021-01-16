// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../services/algolia/algolia_search_service.dart';
import '../services/auth/auth_service.dart';
import '../services/firestore/cause_data_service.dart';
import '../ui/views/home/tabs/explore/explore_view_model.dart';
import '../ui/views/home/tabs/home/home_view_model.dart';
import '../services/firestore/post_data_service.dart';
import '../ui/views/home/tabs/profile/profile_view_model.dart';
import '../services/services_module.dart';
import '../services/firestore/user_data_service.dart';
import '../ui/views/user/user_view_model.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final servicesModule = _$ServicesModule();
  gh.lazySingleton<AlgoliaSearchService>(
      () => servicesModule.algoliaSearchService);
  gh.lazySingleton<AuthService>(() => servicesModule.authService);
  gh.lazySingleton<BottomSheetService>(() => servicesModule.bottomSheetService);
  gh.lazySingleton<CauseDataService>(() => servicesModule.causeDataService);
  gh.lazySingleton<DialogService>(() => servicesModule.dialogService);
  gh.lazySingleton<NavigationService>(() => servicesModule.navigationService);
  gh.lazySingleton<PostDataService>(() => servicesModule.postDataService);
  gh.lazySingleton<SnackbarService>(() => servicesModule.snackBarService);
  gh.lazySingleton<ThemeService>(() => servicesModule.themeService);
  gh.lazySingleton<UserDataService>(() => servicesModule.userDataService);

  // Eager singletons must be registered in the right order
  gh.singleton<ExploreViewModel>(ExploreViewModel());
  gh.singleton<HomeViewModel>(HomeViewModel());
  gh.singleton<ProfileViewModel>(ProfileViewModel());
  gh.singleton<UserViewModel>(UserViewModel());
  return get;
}

class _$ServicesModule extends ServicesModule {
  @override
  AlgoliaSearchService get algoliaSearchService => AlgoliaSearchService();
  @override
  AuthService get authService => AuthService();
  @override
  BottomSheetService get bottomSheetService => BottomSheetService();
  @override
  CauseDataService get causeDataService => CauseDataService();
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  PostDataService get postDataService => PostDataService();
  @override
  SnackbarService get snackBarService => SnackbarService();
  @override
  UserDataService get userDataService => UserDataService();
}
