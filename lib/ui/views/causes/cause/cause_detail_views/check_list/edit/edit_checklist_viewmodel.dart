import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/cause_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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

  updateChecklist(id, actions, descriptors) async {
    //_causeDataService.updateList(id, actions, descriptors);
    navigateBack();
  }

  // String actions1() {
  //   return actions[1];
  // }

  navigateBack() {
    _navigationService.back();
  }
}
