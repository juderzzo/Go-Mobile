import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/services/firestore/platform_data_service.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomDialogService {
  DialogService? _dialogService = locator<DialogService>();
  NavigationService? _navigationService = locator<NavigationService>();
  PlatformDataService? _platformDataService = locator<PlatformDataService>();

  showErrorDialog({required String description}) async {
    _dialogService!.showDialog(
      barrierDismissible: true,
      title: "Error",
      description: description,
      buttonTitle: "Ok",
    );
  }

  showSuccessDialog({required String title, required String description}) async {
    _dialogService!.showDialog(
      barrierDismissible: true,
      title: title,
      description: description,
      buttonTitle: "Ok",
    );
  }

  // showAuthDialog() async {
  //   var response = await _dialogService.showCustomDialog(
  //     barrierDismissible: false,
  //     variant: DialogType.loginDialog,
  //   );
  // }
  //
  // showLoginRequiredDialog({required String description}) async {
  //   DialogResponse? response = await _dialogService.showDialog(
  //     title: "Login Required",
  //     description: description,
  //     barrierDismissible: true,
  //     buttonTitle: "Log In",
  //     cancelTitle: "Cancel",
  //   );
  //   if (response != null) {
  //     if (response.confirmed) {
  //       _navigationService.navigateTo(Routes.AuthViewRoute);
  //     }
  //   }
  // }
  //
  // showPostDeletedDialog() {
  //   _dialogService.showDialog(
  //     barrierDismissible: true,
  //     title: "Post Deleted",
  //     description: "Your post has been deleted",
  //     buttonTitle: "Ok",
  //   );
  // }
  //
  // showCancelContentDialog({required bool isEditing, required String contentType}) async {
  //   DialogResponse? response = await _dialogService.showDialog(
  //     title: isEditing ? "Cancel Editing ${contentType}?" : "Cancel Creating ${contentType}?",
  //     description:
  //     isEditing ? "Changes to this ${contentType.toLowerCase()} will not be saved" : "The details for this  ${contentType.toLowerCase()} will not be saved",
  //     cancelTitle: "Cancel",
  //     cancelTitleColor: appDestructiveColor(),
  //     buttonTitle: isEditing ? "Discard Changes" : "Discard Stream",
  //     buttonTitleColor: appTextButtonColor(),
  //     barrierDismissible: true,
  //   );
  //   if (response != null && !response.confirmed) {
  //     _navigationService.back();
  //   }
  // }
  //
}
