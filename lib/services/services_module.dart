import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import 'firestore/user_data_service.dart';

///RUN "flutter pub run build_runner build" in Project Terminal to Generate Service Modules

@module
abstract class ServicesModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  AuthService get authService;
  @lazySingleton
  UserDataService get userDataService;
  @lazySingleton
  CauseDataService get causeDataService;
}
