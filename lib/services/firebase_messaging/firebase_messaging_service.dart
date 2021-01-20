import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/firestore/user_data_service.dart';

class FirebaseMessagingService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final CollectionReference notificationRef = FirebaseFirestore.instance.collection("notifications");
  UserDataService _userDataService = locator<UserDataService>();
//** FIREBASE MESSAGING  */
  configFirebaseMessaging() {
    String messageTitle;
    String messageBody;
    String messageType;
    String messageData;

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );

    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: false,
        alert: true,
        badge: true,
      ),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings iosSetting) {
      //print('ios settings registered');
    });
  }

  updateFirebaseMessageToken(String uid) {
    firebaseMessaging.getToken().then((token) {
      _userDataService.updateUserMessageToken(uid, token);
    });
  }
}
