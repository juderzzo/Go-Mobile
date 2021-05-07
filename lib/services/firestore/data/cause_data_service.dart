import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/firestore/utils/firebase_storage_service.dart';
import 'package:go/utils/mail_sender.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseDataService {
  CollectionReference causeRef = FirebaseFirestore.instance.collection('causes');
  CollectionReference checkRef = FirebaseFirestore.instance.collection('checks');
  SnackbarService? _snackbarService = locator<SnackbarService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  PostDataService? _postDataService = locator<PostDataService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

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

  Future<bool> createCause({required GoCause cause, required File? img1, required File? img2, required File? img3}) async {
    bool created = true;
    mail();

    cause.dateCreatedInMilliseconds = DateTime.now().millisecondsSinceEpoch;

    if (img1 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img1,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "1",
      );
      if (imgURL != null) {
        cause.imageURLs!.add(imgURL);
      }
    }
    if (img2 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img2,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "2",
      );
      if (imgURL != null) {
        cause.imageURLs!.add(imgURL);
      }
    }
    if (img3 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img3,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "3",
      );
      if (imgURL != null) {
        cause.imageURLs!.add(imgURL);
      }
    }

    mail(id: cause.id);

    await causeRef.doc(cause.id).set(cause.toMap()).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
      created = false;
    });
    return created;
  }

  Future<bool> updateCause({required GoCause cause, required File? img1, required File? img2, required File? img3}) async {
    bool updated = true;
    mail();

    cause.dateCreatedInMilliseconds = DateTime.now().millisecondsSinceEpoch;

    if (img1 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img1,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "1",
      );
      if (imgURL != null) {
        cause.imageURLs![0] = imgURL;
      }
    }

    if (img2 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img2,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "2",
      );
      if (cause.imageURLs!.length >= 2) {
        if (imgURL != null) {
          cause.imageURLs![1] = imgURL;
        }
      }
    }

    if (img3 != null) {
      String? imgURL = await _firebaseStorageService.uploadImage(
        img: img3,
        storageBucket: 'images',
        folderName: 'causes',
        fileName: cause.id! + "3",
      );
      if (cause.imageURLs!.length >= 3) {
        if (imgURL != null) {
          cause.imageURLs![2] = imgURL;
        }
      }
    }

    mail(id: cause.id);

    await causeRef.doc(cause.id).set(cause.toMap()).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
      updated = false;
    });

    return updated;
  }

  Future getCauseByID(String? id) async {
    GoCause? cause;
    DocumentSnapshot snapshot = await causeRef.doc(id).get().catchError((e) {
      _snackbarService!.showSnackbar(
        title: 'Cause Load Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return null;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data()!;
      cause = GoCause.fromMap(snapshotData);
    }
    return cause;
  }

  Future addView(String causeID) async {
    DocumentReference cause = causeRef.doc(causeID);
    GoCause rev = await (getCauseByID(causeID) as FutureOr<GoCause>);
    cause.update({"revenue": rev.revenue! + 1});
  }

  Future updateAdmins(GoCause cause) async {
    DocumentReference causeR = causeRef.doc(cause.id);
    causeR.update({"admins": cause.admins});
  }

  Future followUnfollowCause(String? causeID, String? uid) async {
    GoCause? cause;
    DocumentSnapshot snapshot = await causeRef.doc(causeID).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data()!;
      cause = GoCause.fromMap(snapshotData);
      List causeFollowers = cause.followers!.toList(growable: true);
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
  Future<List<GoCheckListItem>> getCheckListItems(String? causeID) async {
    List<GoCheckListItem> causeCheckListItems = [];
    QuerySnapshot snapshot = await checkRef.where("causeID", isEqualTo: causeID).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) {
        GoCheckListItem item = GoCheckListItem.fromMap(doc.data());
        causeCheckListItems.add(item);
      });
    }
    return causeCheckListItems;
  }

  Future<bool> updateCheckListItems({String? causeID, required List<GoCheckListItem> items}) async {
    bool updated = true;
    //delete old instances of check list items
    QuerySnapshot snapshot = await checkRef.where("causeID", isEqualTo: causeID).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) async {
        await checkRef.doc(doc.id).delete().catchError((e) {
          _snackbarService!.showSnackbar(
            title: 'Action List Submission Error',
            message: "There was an issues submitting your checklist. Please try again.",
            duration: Duration(seconds: 5),
          );
          return false;
        });
      });
    }
    //upload new instances of check list items
    items.forEach((item) async {
      await checkRef.doc(item.id).set(item.toMap()).catchError((e) {
        _snackbarService!.showSnackbar(
          title: 'Action List Submission Error',
          message: "There was an issues submitting your checklist. Please try again.",
          duration: Duration(seconds: 5),
        );
        return false;
      });
    });
    return updated;
  }

  Future<bool> checkOffCheckListItem({String? id, List? checkedOffBy}) async {
    await checkRef.doc(id).update({'checkedOffBy': checkedOffBy}).catchError((e) {
      _snackbarService!.showSnackbar(
        title: 'Error',
        message: "There was an issues signing off this item. Please try again.",
        duration: Duration(seconds: 5),
      );
      return false;
    });
    return true;
  }

  ///QUERIES
  //Load Cause by Follower Count
  Future<List<DocumentSnapshot>> loadCauses({
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef.orderBy('followerCount', descending: true).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService!.showSnackbar(
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
    required String uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    String? error;
    Query query = causeRef.where('followers', arrayContains: uid).orderBy('followerCount', descending: true).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
      error = e.message;
    });

    if (error != null) {
      print(error);
      return docs;
    }

    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  //Load Causes Created
  Future<List<DocumentSnapshot>> loadCausesCreated({
    required String? uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef.where('creatorID', isEqualTo: uid).orderBy('followerCount', descending: true).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService!.showSnackbar(
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
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef.orderBy('followerCount', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService!.showSnackbar(
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
    required DocumentSnapshot lastDocSnap,
    required String? uid,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef.where('followers', arrayContains: uid).orderBy('followerCount', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService!.showSnackbar(
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
    required DocumentSnapshot lastDocSnap,
    required String? uid,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef.where('creatorID', isEqualTo: uid).orderBy('followerCount', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);

    QuerySnapshot snapshot = await query.get().catchError((e) {
      _snackbarService!.showSnackbar(
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

  Future deleteCause(String? id) async {
    //first you have to delet the posts in this cause, so get all the posts
    //where the cause ID is the same as this
    QuerySnapshot posts = await FirebaseFirestore.instance.collection('posts').where('causeID', isEqualTo: id).get();

    for (int i = 0; i < posts.docs.length; i++) {
      _postDataService!.deletePost(posts.docs[i].reference.id);
    }

    //delete the cause and the images associated with it
    await FirebaseFirestore.instance.runTransaction((Transaction deleteTransaction) async {
      GoCause cause = await (getCauseByID(id) as FutureOr<GoCause>);
      List imageURLs = cause.imageURLs!;
      imageURLs.forEach((url) {
        FirebaseStorage.instance.refFromURL(url).delete();
      });
      //delete the images first

      await deleteTransaction.delete(causeRef.doc(id));
    });
  }
}
