import 'package:go/locator.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';

import 'base_model.dart';

class SignInPageModel extends BaseModel {
  AuthService authService = locator<AuthService>();
  DialogService dialogService = locator<DialogService>();
  NavigationService navigationService = locator<NavigationService>();
}
