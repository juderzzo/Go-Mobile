import 'package:go/app/app.locator.dart';
import 'package:go/enums/dialog_type.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomDialogService {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  // PlatformDataService? _platformDataService = locator<PlatformDataService>();

  showErrorDialog({required String description}) async {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Error",
      description: description,
      buttonTitle: "Ok",
    );
  }

  showSuccessDialog({required String title, required String description}) async {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: title,
      description: description,
      buttonTitle: "Ok",
    );
  }

  showAppSettingsDialog({required String title, required String description}) async {
    DialogResponse? response =
        await _dialogService.showDialog(barrierDismissible: true, title: title, description: description, buttonTitle: "Open App Settings");
    if (response != null && response.confirmed) {
      openAppSettings();
    }
  }

  showCauseDeletedDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Cause Deleted",
      description: "Your cause has been deleted",
      buttonTitle: "Ok",
    );
  }

  showPostDeletedDialog() {
    _dialogService.showDialog(
      barrierDismissible: true,
      title: "Post Deleted",
      description: "Your post has been deleted",
      buttonTitle: "Ok",
    );
  }

  Future<GoCheckListItem?> showActionItemFormDialog({GoCheckListItem? item}) async {
    GoCheckListItem? result;
    DialogResponse? response = await _dialogService.showCustomDialog(
      barrierDismissible: false,
      customData: {'item': item != null ? item : null},
      variant: DialogType.actionItemForm,
    );
    if (response != null) {
      result = response.responseData;
    }
    return result;
  }
}
