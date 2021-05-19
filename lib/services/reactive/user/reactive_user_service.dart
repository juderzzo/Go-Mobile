import 'package:go/models/go_user_model.dart';
import 'package:stacked/stacked.dart';

class ReactiveUserService with ReactiveServiceMixin {
  final _userLoggedIn = ReactiveValue<bool>(false);
  final _user = ReactiveValue<GoUser>(GoUser());

  bool get userLoggedIn => _userLoggedIn.value;
  GoUser get user => _user.value;

  void updateUserLoggedIn(bool val) => _userLoggedIn.value = val;
  void updateUser(GoUser val) => _user.value = val;

  ReactiveUserService() {
    listenToReactiveValues([_userLoggedIn, _user]);
  }
}
