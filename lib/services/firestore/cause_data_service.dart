import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_checklist_model.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:go/utils/random_string_generator.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseDataService {
  CollectionReference causeRef =
      FirebaseFirestore.instance.collection('causes');

  CollectionReference checkRef =
      FirebaseFirestore.instance.collection('checks');

  SnackbarService _snackbarService = locator<SnackbarService>();

  Future checkIfCauseExists(String id) async {
    bool exists = false;
    DocumentSnapshot snapshot = await causeRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      exists = true;
    }
    return exists;
  }

  Future createCause({
    String creatorID,
    String name,
    String goal,
    String why,
    String who,
    String resources,
    String charityURL,
    List actions,
    List actionDescriptions,
    File img1,
    File img2,
    File img3,
  }) async {
    GoCause cause = GoCause(
      id: getRandomString(35),
      creatorID: creatorID,
      dateCreatedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      name: name,
      goal: goal,
      why: why,
      who: who,
      resources: resources,
      charityURL: charityURL,
      actions: actions,
      actionDescriptions: actionDescriptions,
      imageURLs: [],
      followers: [creatorID],
      followerCount: 1,
      forumPostCount: 0,
    );

    if (img1 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img1,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs.add(imgURL);
    }
    if (img2 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img2,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs.add(imgURL);
    }
    if (img3 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img3,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs.add(imgURL);
    }
    await causeRef.doc(cause.id).set(cause.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future getCauseByID(String id) async {
    GoCause cause;
    DocumentSnapshot snapshot = await causeRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      cause = GoCause.fromMap(snapshotData);
    }
    return cause;
  }

  Future followUnfollowCause(String causeID, String uid) async {
    GoCause cause;
    DocumentSnapshot snapshot =
        await causeRef.doc(causeID).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      cause = GoCause.fromMap(snapshotData);
      List causeFollowers = cause.followers.toList(growable: true);
      if (causeFollowers.contains(uid)) {
        causeFollowers.remove(uid);
      } else {
        causeFollowers.add(uid);
      }
      await causeRef.doc(cause.id).update({
        "followers": causeFollowers,
        "followerCount": causeFollowers.length,
      }).catchError((e) {
        return e.message;
      });
    }
    return cause;
  }

  //Checklist

  Future<void> pushItem(GoChecklistItem item) async {
    await checkRef.doc(item.id).set({
      'id': item.id,
      'header': item.item.header,
      'subheader': item.item.subHeader,
    });
  }

  Future<List> getItem(id) async {
    DocumentSnapshot snapshot = await checkRef.doc(id).get();
    Map<String, dynamic> snapshotData = snapshot.data();
    return [
      snapshotData['id'],
      snapshotData['header'],
      snapshotData['subheader']
    ];
  }

  Future<bool> checkExists(id) async {
    await checkRef.doc(id).get().catchError((onError) {
      return true;
    });
    return false;
  }

  Future updateList(String causeID, items) async {
    await causeRef.doc(causeID).update({
      //link up the actions to the list of causeIDs
      "actions": items,
    });
  }

  ///QUERIES
  //Load Cause by Follower Count
  Future<List<DocumentSnapshot>> loadCauses({
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query =
        causeRef.orderBy('followerCount', descending: true).limit(resultsLimit);
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

  //Load Causes Following
  Future<List<DocumentSnapshot>> loadCausesFollowing({
    @required String uid,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef
        .where('followers', arrayContains: uid)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);

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

  //Load Causes Created
  Future<List<DocumentSnapshot>> loadCausesCreated({
    @required String uid,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);

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

  //Load Additional Causes by Follower Count
  Future<List<DocumentSnapshot>> loadAdditionalCauses({
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  //Load Additional Causes Following
  Future<List<DocumentSnapshot>> loadAdditionalCausesFollowing({
    @required DocumentSnapshot lastDocSnap,
    @required String uid,
    @required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .where('followers', arrayContains: uid)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  //Load Additional Causes Created
  Future<List<DocumentSnapshot>> loadAdditionalCausesCreated({
    @required DocumentSnapshot lastDocSnap,
    @required String uid,
    @required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  Future<bool> deleteCause(String id) async {
    //delete the cause and the images associated with it
    await FirebaseFirestore.instance
        .runTransaction((Transaction deleteTransaction) async {
      GoCause cause = await getCauseByID(id);
      List imageURLs = cause.imageURLs;
      imageURLs.forEach((url) {
        FirebaseStorage.instance.refFromURL(url).delete();
      });
      //delete the images first

      await deleteTransaction.delete(causeRef.doc(id));
    });
  }
}
