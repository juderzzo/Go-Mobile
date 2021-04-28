import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  ///SERVICES
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();

  ///USER DATA
  GoUser get user => _reactiveUserService.user;
}
