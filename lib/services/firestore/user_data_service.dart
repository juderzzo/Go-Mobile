import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/models/go_user_model.dart';

class UserDataService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  Future checkIfUserExists(String id) async {
    bool exists = false;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      exists = true;
    }
    return exists;
  }

  Future createGoUser(GoUser user) async {
    await userRef.doc(user.id).set(user.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future getGoUserByID(String id) async {
    GoUser user;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      user = GoUser.fromMap(snapshotData);
    }
    return user;
  }

  Future updateGoUser(GoUser user) async {
    await userRef.doc(user.id).update(user.toMap()).catchError((e) {
      return e.message;
    });
  }

  ///TESTING
  Future generateDummyUserFromID(String id) async {
    GoUser user = GoUser().generateDummyUserFromID(id);
    var res = await createGoUser(user);
    return res;
  }
}
