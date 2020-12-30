import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@singleton
class HomeViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  CollectionReference causesRef =
      FirebaseFirestore.instance.collection("causes");

  List<DocumentSnapshot> causesResults = [];
  DocumentSnapshot lastCauseDocSnap;
  bool loadingAdditionalCauses = false;
  bool moreCausesAvailable = true;

  String currentUID;
  List causes = [];

  initialize() async {
    setBusy(true);
    currentUID = await _authService.getCurrentUserID();
    getCauses();
    setBusy(false);
    notifyListeners();
  }

  getCauses() async {
    Query query;
    query = causesRef
        .orderBy('dateCreatedInMilliseconds', descending: true)
        .limit(10);
    QuerySnapshot querySnapshot = await query.get().catchError((e) {
      print(e);
    });
    if (querySnapshot.docs.isNotEmpty) {
      lastCauseDocSnap = querySnapshot.docs[querySnapshot.docs.length - 1];
      causesResults = querySnapshot.docs;
      causesResults.forEach((doc) {
        GoCause cause = GoCause.fromMap(doc.data());
        causes.add(cause);
      });
      notifyListeners();
    }
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
  navigateToCreateCauseView() {
    _navigationService.navigateTo(Routes.CreateCauseViewRoute);
  }
}
