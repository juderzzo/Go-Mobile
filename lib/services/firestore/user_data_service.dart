import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:go/utils/random_string_generator.dart';
import 'package:stacked_services/stacked_services.dart';

class UserDataService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  SnackbarService _snackbarService = locator<SnackbarService>();

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

  Future checkIfUserHasBeenOnboarded(String id) async {
    bool onboarded = false;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      onboarded = snapshot.data()['onboarded'] == null ? false : snapshot.data()['onboarded'];
    }
    return onboarded;
  }

  Future checkIfUsernameExists(String uid, String username) async {
    bool exists = false;
    QuerySnapshot snapshot = await userRef.where('username', isEqualTo: username).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) {
        if (doc.id != uid) {
          exists = true;
        }
      });
    }
    return exists;
  }

  Future createGoUser({
    @required String id,
    @required String fbID,
    @required String googleID,
    @required String email,
    @required String phoneNo,
  }) async {
    GoUser newUser = GoUser().generateNewUser(
      id: id,
      fbID: fbID,
      googleID: googleID,
      email: email,
      phoneNo: phoneNo,
    );
    await userRef.doc(newUser.id).set(newUser.toMap()).catchError((e) {
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

  Future updateGoUserName(String id, String username) async {
    await userRef.doc(id).update({
      "username": username,
    }).catchError((e) {
      return e.message;
    });
  }

  Future updateGoUserBio(String id, String bio) async {
    await userRef.doc(id).update({
      "bio": bio,
      "onboarded": true,
    }).catchError((e) {
      return e.message;
    });
  }

  Future updateProfilePic(String id, File img) async {
    String imgURL = await FirestoreImageUploader().uploadImage(
      img: img,
      storageBucket: 'users',
      folderName: id,
      fileName: getRandomString(10) + ".png",
    );
    await userRef.doc(id).update({
      "profilePicURL": imgURL,
    }).catchError((e) {
      return e.message;
    });
  }

  Future updateBio(String id, String bio) async {
    await userRef.doc(id).update({
      "bio": bio,
    }).catchError((e) {
      return e.message;
    });
  }

  ///QUERIES
  //Load Users by Follower Count
  Future<List<DocumentSnapshot>> loadUsers({
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = userRef.orderBy('followerCount', descending: true).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return docs;
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  //Load Additional Users by Follower Count
  Future<List<DocumentSnapshot>> loadAdditionalUsers({
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = userRef.orderBy('followerCount', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
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

  ///TESTING
  Future generateDummyUserFromID(String id) async {
    GoUser user = GoUser().generateDummyUserFromID(id);
    //var res = await createGoUser(user);
    //return res;
  }
}
