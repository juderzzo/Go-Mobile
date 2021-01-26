import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/edit/edit_checklist_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckListViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();

  List<bool> checks = [false, false, false];

  void indexChanger(int index) {
    checks[index] = true;
  }

  Future<String> userID() async {
    return await _authService.getCurrentUserID();
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }

  navigateToEdit(actions, descriptors, creatorID, currentUID, name, causeID ) {
    _navigationService.navigateTo(Routes.EditChecklistView, arguments: {
      'actions': actions,
      'descriptors': descriptors,
      'creatorID': creatorID,
      'currentUID': currentUID,
      'name': name,
      'causeID': causeID});
    // String data = await _navigationService
    //     .navigateTo(Routes.EditChecklistView, arguments: {
    //   'actions': actions,
    //   'descriptors': descriptors,
    //   'creatorID': creatorID,
    //   'currentUID': currentUID
    // });
    // print(data);
  }
}
