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
  CollectionReference causeRef =
      FirebaseFirestore.instance.collection('causes');
  CollectionReference checkRef =
      FirebaseFirestore.instance.collection('checks');
  SnackbarService? _snackbarService = locator<SnackbarService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  PostDataService _postDataService = locator<PostDataService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

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

  Future<bool> createCause(
      {required GoCause cause,
      required File? img1,
      required File? img2,
      required File? img3}) async {
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
    cause.approved = true;
    await causeRef.doc(cause.id).set(cause.toMap()).catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
      created = false;
    });
    return created;
  }

  Future<bool> updateCause(
      {required GoCause cause,
      required File? img1,
      required File? img2,
      required File? img3}) async {
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
      if (imgURL != null) {
        if (cause.imageURLs!.length >= 2) {
          cause.imageURLs![1] = imgURL;
        } else {
          cause.imageURLs!.add(imgURL);
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
      if (imgURL != null) {
        if (cause.imageURLs!.length >= 3) {
          cause.imageURLs![2] = imgURL;
        } else {
          cause.imageURLs!.add(imgURL);
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

  Future<GoCause> getCauseByID(String? id) async {
    GoCause cause = GoCause();
    String? error;
    DocumentSnapshot snapshot = await causeRef.doc(id).get().catchError((e) {
      error = e.message;
      _snackbarService!.showSnackbar(
        title: 'Cause Load Error',
        message: error!,
        duration: Duration(seconds: 5),
      );
    });
    if (error != null) {
      return cause;
    }
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data()!;
      cause = GoCause.fromMap(snapshotData);
    }
    return cause;
  }

  Future addView(String causeID) async {
    DocumentReference cause = causeRef.doc(causeID);
    GoCause rev = await getCauseByID(causeID);
    cause.update({"revenue": rev.revenue! + 1});
  }

  Future updateAdmins(GoCause cause) async {
    DocumentReference causeR = causeRef.doc(cause.id);
    causeR.update({"admins": cause.admins});
  }

  Future<List> getCauseFollowers(String? id) async {
    List followers = [];
    String? error;
    DocumentSnapshot snapshot = await causeRef.doc(id).get().catchError((e) {
      error = e.message;
    });
    if (error == null) {
      return followers;
    }
    if (snapshot.exists) {
      GoCause cause = GoCause.fromMap(snapshot.data()!);
      followers = cause.followers ?? [];
    }
    return followers;
  }

  Future followUnfollowCause(String? causeID, String? uid) async {
    GoCause? cause;
    DocumentSnapshot snapshot =
        await causeRef.doc(causeID).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data()!;
      cause = GoCause.fromMap(snapshotData);
      List causeFollowers = cause.followers!.toList(growable: true);
      if (causeFollowers.contains(uid)) {
        causeFollowers.remove(uid);
        _postDataService.unfollowPosts(uid: uid!, causeID: causeID!);
      } else {
        causeFollowers.add(uid);
        _postDataService.followPosts(uid: uid!, causeID: causeID!);
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

  reportCause({required String? causeID, required String? reporterID}) async {
    String? error;
    DocumentSnapshot snapshot =
        await causeRef.doc(causeID).get().catchError((e) {
      _customDialogService.showErrorDialog(description: e.message);
      error = e.message;
    });
    if (error != null) {
      return;
    }
    if (snapshot.exists) {
      List reportedBy = snapshot.data()!['reportedBy'] == null
          ? []
          : snapshot.data()!['reportedBy'].toList(growable: true);
      if (reportedBy.contains(reporterID)) {
        _customDialogService.showErrorDialog(
            description:
                "You've already reported this cause. This cause is currently pending review.");
        return;
      } else {
        reportedBy.add(reporterID);
        causeRef.doc(causeID).update({"reportedBy": reportedBy});
        _customDialogService.showSuccessDialog(
            title: 'Cause Reported',
            description: "This cause is now pending review");
        return;
      }
    }
  }

  //Checklist
  Future<List<GoCheckListItem>> getCheckListItems(String? causeID) async {
    List<GoCheckListItem> causeCheckListItems = [];
    QuerySnapshot snapshot =
        await checkRef.where("causeID", isEqualTo: causeID).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) {
        GoCheckListItem item = GoCheckListItem.fromMap(doc.data());
        causeCheckListItems.add(item);
      });
    }
    return causeCheckListItems;
  }

  Future<bool> updateCheckListItems(
      {String? causeID, required List<GoCheckListItem> items}) async {
    bool updated = true;
    //delete old instances of check list items
    QuerySnapshot snapshot =
        await checkRef.where("causeID", isEqualTo: causeID).get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) async {
        await checkRef.doc(doc.id).delete().catchError((e) {
          _snackbarService!.showSnackbar(
            title: 'Action List Submission Error',
            message:
                "There was an issues submitting your checklist. Please try again.",
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
          message:
              "There was an issues submitting your checklist. Please try again.",
          duration: Duration(seconds: 5),
        );
        return false;
      });
    });
    return updated;
  }

  Future<bool> checkOffCheckListItem({String? id, List? checkedOffBy}) async {
    await checkRef
        .doc(id)
        .update({'checkedOffBy': checkedOffBy}).catchError((e) {
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
    Query query = causeRef
        .where('approved', isEqualTo: true)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);
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
    query = causeRef
        .where('approved', isEqualTo: true)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  //Load Causes Following
  Future<List<DocumentSnapshot>> loadCausesFollowing({
    required String uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    String? error;
    Query query = causeRef
        .where('approved', isEqualTo: true)
        .where('followers', arrayContains: uid)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);

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

  //Load Additional Causes Following
  Future<List<DocumentSnapshot>> loadAdditionalCausesFollowing({
    required DocumentSnapshot lastDocSnap,
    required String? uid,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .where('approved', isEqualTo: true)
        .where('followers', arrayContains: uid)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  //Load Causes Created
  Future<List<DocumentSnapshot>> loadCausesCreated({
    required String? uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef
        .where("approved", isEqualTo: true)
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);

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

  //Load Additional Causes Created
  Future<List<DocumentSnapshot>> loadAdditionalCausesCreated({
    required DocumentSnapshot lastDocSnap,
    required String? uid,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .where("approved", isEqualTo: true)
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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

  //Load Causes Created
  Future<List<DocumentSnapshot>> loadCausesCurrentUserCreated({
    required String? uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = causeRef
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .limit(resultsLimit);

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

  //Load Additional Causes Created
  Future<List<DocumentSnapshot>> loadAdditionalCausesCurrentUserCreated({
    required DocumentSnapshot lastDocSnap,
    required String? uid,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = causeRef
        .where('creatorID', isEqualTo: uid)
        .orderBy('followerCount', descending: true)
        .startAfterDocument(lastDocSnap)
        .limit(resultsLimit);

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
    QuerySnapshot posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('causeID', isEqualTo: id)
        .get();

    for (int i = 0; i < posts.docs.length; i++) {
      _postDataService.deletePost(posts.docs[i].reference.id);
    }

    //delete the cause and the images associated with it
    await FirebaseFirestore.instance
        .runTransaction((Transaction deleteTransaction) async {
      GoCause cause = await getCauseByID(id);
      List imageURLs = cause.imageURLs!;
      imageURLs.forEach((url) {
        FirebaseStorage.instance.refFromURL(url).delete();
      });
      //delete the images first

      await deleteTransaction.delete(causeRef.doc(id));
    });
  }
}
