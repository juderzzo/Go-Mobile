import 'package:go/app/app.locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';

class CommentTextFieldViewModel extends ReactiveViewModel {
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  ///USER DATA
  GoUser get user => _reactiveUserService.user;

  List<GoUser> mentionedUsers = [];

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveUserService];

  addUserToMentions(GoUser user) {
    mentionedUsers.add(user);
    notifyListeners();
  }

  List<GoUser> getMentionedUsers({String? commentText}) {
    mentionedUsers.forEach((user) {
      if (!commentText!.contains(user.username!)) {
        mentionedUsers.remove(user);
      }
    });
    notifyListeners();
    return mentionedUsers;
  }

  clearMentionedUsers() {
    mentionedUsers = [];
    notifyListeners();
  }
}
