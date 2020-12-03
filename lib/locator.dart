import 'package:get_it/get_it.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';

import 'services/auth/auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //General
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  //Auth
  locator.registerLazySingleton(() => AuthService());
}
