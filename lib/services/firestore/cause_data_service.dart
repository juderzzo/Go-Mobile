import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:go/utils/random_string_generator.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseDataService {
  CollectionReference causeRef =
      FirebaseFirestore.instance.collection('causes');
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
      imageURLs: [],
      followers: [creatorID],
      followersCount: 1,
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

  ///READS & QUERIES
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

  Future<List<DocumentSnapshot>> loadAdditionalCauses({
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
}
