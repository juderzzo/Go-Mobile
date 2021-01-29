import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_checklist_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'edit_checklist_view.dart';

class EditChecklistViewModel extends BaseViewModel {
  // final List actions;
  // final List descriptors;
  // final String creatorId;
  // final String currentUID;

  // EditChecklistViewModel(
  //     {this.actions, this.descriptors, this.creatorId, this.currentUID});

  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  navigateToCauseView() {
    _navigationService.navigateTo(Routes.CauseViewRoute);
  }

  updateChecklist(List<CheckField> dynamicList, String causeID) async {
    //first get the data from the
    List<String> newActions = [];
    List<GoChecklistItem> items = [];
    for (int i = 0; i < dynamicList.length; i++) {
      print(dynamicList[i].header);
      print(dynamicList[i].subheader);
      newActions.add(dynamicList[i].id);
      items.add(GoChecklistItem(
          id: dynamicList[i].id,
          item: CauseCheckListItem(
            id: dynamicList[i].id,
            header: dynamicList[i].header,
            subHeader: dynamicList[i].subheader,
            isChecked: false,
          )));
    }

    _causeDataService.updateList(causeID, newActions);

    for (int i = 0; i < newActions.length; i++) {
      bool exists = await _causeDataService.checkExists(newActions[i]);
      if (!exists) {
        await _causeDataService.pushItem(items[i]);
      }
    }
    navigateToCause(causeID);
  }

  // String actions1() {
  //   return actions[1];
  // }

  navigateBack() {
    _navigationService.back();
  }

  navigateToCause(id) {
    _navigationService.navigateTo(Routes.CauseViewRoute, arguments: {'id': id});
  }
}
