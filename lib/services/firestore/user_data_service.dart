import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:go/utils/random_string_generator.dart';

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

  ///TESTING
  Future generateDummyUserFromID(String id) async {
    GoUser user = GoUser().generateDummyUserFromID(id);
    var res = await createGoUser(user);
    return res;
  }
}
