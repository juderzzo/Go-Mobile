import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:stacked/stacked.dart';

class FeedViewModel extends BaseViewModel {
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();

  ///CURRENT USER
  GoUser get user => _reactiveUserService.user;
}
