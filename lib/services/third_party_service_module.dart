import 'package:go/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

///RUN "flutter pub run build_runner build" in Project Terminal to Generate Service Modules

@module
abstract class ThirdPartyServiceModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  AuthService get authService;
}
