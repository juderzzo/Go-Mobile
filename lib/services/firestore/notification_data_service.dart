import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationDataService {
  SnackbarService _snackbarService = locator<SnackbarService>();
  CollectionReference notifsRef = FirebaseFirestore.instance.collection("notifications");

  Future sendNotification({
    @required GoNotification notif,
  }) async {
    String notifID = notif.receiverUID + "-" + notif.timePostedInMilliseconds.toString();
    await notifsRef.doc(notifID).set(notif.toMap()).catchError((e) {
      return e.message;
    });
  }

  ///QUERY DATA
  //Load Comments Created
  Future<List<DocumentSnapshot>> loadNotifications({
    @required String uid,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    QuerySnapshot snapshot =
        await notifsRef.where('receiverUID', isEqualTo: uid).orderBy('expDateInMilliseconds', descending: true).limit(15).get().catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  //Load Additional Causes by Follower Count
  Future<List<DocumentSnapshot>> loadAdditionalNotifications({
    @required String uid,
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    QuerySnapshot snapshot = await notifsRef
        .where('receiverUID', isEqualTo: uid)
        .orderBy('expDateInMilliseconds', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(15)
        .get()
        .catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }
}
