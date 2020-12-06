import 'package:go/locator.dart';
import 'package:go/routes/route_names.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/navigation_service.dart';

import 'base_model.dart';

class RootPageModel extends BaseModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();

  Future checkAuthState() async {
    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      _navigationService.replaceWith(HomePageRoute);
    } else {
      _navigationService.replaceWith(SignInPageRoute);
    }
  }
}
