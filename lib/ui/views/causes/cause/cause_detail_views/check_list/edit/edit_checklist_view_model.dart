import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/notification_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditCheckListViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  NavigationService? _navigationService = locator<NavigationService>();
  CauseDataService? _causeDataService = locator<CauseDataService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  UserDataService? _userDataService = locator<UserDataService>();
  NotificationDataService? _notificationDataService = locator<NotificationDataService>();

  GoCause? cause;
  String? currentUID;
  bool send = false;
  List<GoCheckListItem> checkListItems = [];

  initialize(String? id) async {
    setBusy(true);
    String? causeID = id;
    cause = await _causeDataService!.getCauseByID(causeID);
    // print(cause);
    checkListItems = await _causeDataService!.getCheckListItems(causeID);
    currentUID = await _authService!.getCurrentUserID();
    notifyListeners();
    setBusy(false);
  }

  addCheckListItem() {
    GoCheckListItem item =
        GoCheckListItem(id: getRandomString(30), causeID: cause!.id, checkedOffBy: [], dateTimePublished: DateTime.now().millisecondsSinceEpoch, points: 0);
    checkListItems.add(item);
    send = true;
    notifyListeners();
  }

  updateItemHeader({String? id, String? header}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].header = header;
    notifyListeners();
  }

  updateItemSubHeader({String? id, String? subHeader}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].subHeader = subHeader;
    notifyListeners();
  }

  updateItemPoints({String? id, int? points}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].points = points;
    notifyListeners();
  }

  updateItemLocationDetails({String? id, double? lat, double? lon, String? address}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].lat = lat;
    checkListItems[itemIndex].lon = lon;
    checkListItems[itemIndex].address = address;
    notifyListeners();
  }

  deleteItemLocationDetails({String? id}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].lat = null;
    checkListItems[itemIndex].lon = null;
    checkListItems[itemIndex].address = null;
    notifyListeners();
  }

  editItemPoints({String? id, int? points}) {
    int itemIndex = checkListItems.indexWhere((item) => item.id == id);
    checkListItems[itemIndex].points = points;
    notifyListeners();
  }

  deleteCheckListItem({required String id}) {
    for (int i = 0; i < checkListItems.length; i++) {
      if (checkListItems[i].id == id) {
        checkListItems.removeAt(i);
        //i--;
      }
    }
    send = true;
    checkListItems.forEach((element) {});
    notifyListeners();
  }

  bool checkListIsValid() {
    bool isValid = true;
    int numberOfIncompleteItems = 0;
    numberOfIncompleteItems =
        checkListItems.where((item) => item.header == null || item.header!.isEmpty || item.subHeader == null || item.subHeader!.isEmpty).length;
    if (numberOfIncompleteItems > 0) {
      isValid = false;
    }
    return isValid;
  }

  submitCheckList() async {
    if (checkListIsValid()) {
      bool updatedCheckList = false;
      updatedCheckList = await _causeDataService!.updateCheckListItems(causeID: cause!.id, items: checkListItems);
      if (updatedCheckList) {
        if (send) {
          sendChecklistNotifications();
        }
        _navigationService!.popRepeated(2);
        _navigationService!.navigateTo(Routes.CauseViewRoute(id: cause!.id));
      }
    } else {
      _snackbarService!.showSnackbar(
        title: 'Actions Incomplete',
        message: "One or More of Your Actions Items is Incomplete",
        duration: Duration(seconds: 5),
      );
    }
  }

  sendChecklistNotifications() async {
    ///print("chog");
    //get all the cause followers
    _notificationDataService!.getCauseFollowers(cause!.id).then((mentionedUsernames) {
      //print(mentionedUsernames);
      mentionedUsernames!.forEach((username) async {
        // print("chog");
        GoNotification notification = GoNotification().generateGoChecklistNotification(
            causeName: cause!.name.toString(), senderUID: currentUID, receiverUID: username, causeID: cause!.id, isEvent: false);
        //print(notification.toMap());
        _notificationDataService!.sendNotification(notif: notification);
      });
    });
  }
}
