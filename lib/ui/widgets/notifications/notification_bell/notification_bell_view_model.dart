import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/services/firestore/notification_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationBellViewModel extends StreamViewModel<int> {
  NavigationService? _navigationService = locator<NavigationService>();
  NotificationDataService? _notificationDataService = locator<NotificationDataService>();

  String? currentUID;
  int? notifCount = 0;

  initialize(String? uid) async {
    currentUID = uid;
    notifyListeners();
  }

  ///STREAM DATA
  @override
  void onData(int? data) {
    if (data != 0) {
      notifCount = data;
      notifyListeners();
    }
  }

  @override
  Stream<int> get stream => streamUser();

  Stream<int> streamUser() async* {
    while (currentUID != null) {
      await Future.delayed(Duration(seconds: 1));
      var res = await _notificationDataService!.getNumberOfUnreadNotifications(currentUID);
      if (res is String) {
        yield 0;
      } else {
        yield res;
      }
    }
  }

  ///NAVIGATION
  navigateToNotificationsView() {
    notifCount = 0;
    _navigationService!.navigateTo(Routes.NotificationsViewRoute);
    notifyListeners();
  }
}
