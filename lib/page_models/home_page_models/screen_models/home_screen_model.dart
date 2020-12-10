import 'package:go/locator.dart';
import 'package:go/page_models/base_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';

class HomeScreenModel extends BaseModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
