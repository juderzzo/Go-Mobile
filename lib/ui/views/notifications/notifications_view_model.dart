import 'dart:async';

import 'package:go/app/app.locator.dart';
import 'package:go/services/permission_handler/permission_handler_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  PermissionHandlerService _permissionHandlerService = locator<PermissionHandlerService>();

  initialize() async {
    await Future.delayed(Duration(seconds: 3));
    _permissionHandlerService.hasNotificationsPermission();
  }

  navigateBack() {
    _navigationService.back();
  }
}
