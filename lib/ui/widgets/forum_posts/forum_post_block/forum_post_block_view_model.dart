import 'package:go/app/locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostBlockViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  bool isAuthor = false;

  showOptions() async {
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: isAuthor ? BottomSheetType.postAuthorOptions : BottomSheetType.postOptions,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;
      if (res == "edit") {
        //edit
      } else if (res == "share") {
        //share
      } else if (res == "report") {
        //report
      } else if (res == "delete") {
        //delete
      }
      notifyListeners();
    }
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
