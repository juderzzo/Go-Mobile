// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth/auth_service.dart';
import '../services/firestore/cause_data_service.dart';
import '../services/services_module.dart';
import '../services/firestore/user_data_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final servicesModule = _$ServicesModule();
  gh.lazySingleton<AuthService>(() => servicesModule.authService);
  gh.lazySingleton<CauseDataService>(() => servicesModule.causeDataService);
  gh.lazySingleton<DialogService>(() => servicesModule.dialogService);
  gh.lazySingleton<NavigationService>(() => servicesModule.navigationService);
  gh.lazySingleton<UserDataService>(() => servicesModule.userDataService);
  return get;
}

class _$ServicesModule extends ServicesModule {
  @override
  AuthService get authService => AuthService();
  @override
  CauseDataService get causeDataService => CauseDataService();
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  UserDataService get userDataService => UserDataService();
}
