import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends ReactiveViewModel {
  ///SERVICES
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();

  ///USER DATA
  GoUser get user => _reactiveUserService.user;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];
}
