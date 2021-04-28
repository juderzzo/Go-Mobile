import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:go/utils/mail_sender.dart';
import 'package:stacked_services/stacked_services.dart';

class CauseDataService {
  CollectionReference causeRef = FirebaseFirestore.instance.collection('causes');

  CollectionReference checkRef = FirebaseFirestore.instance.collection('checks');

  SnackbarService? _snackbarService = locator<SnackbarService>();

  PostDataService? _postDataService = locator<PostDataService>();

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
    String? creatorID,
    String? name,
    String? goal,
    String? why,
    String? who,
    String? resources,
    String? charityURL,
    List? actions,
    List? admins,
    File? img1,
    File? img2,
    File? img3,
    String? videoLink,
    bool? monetized,
  }) async {
    mail();
    String id = getRandomString(35);
    print(id);
    GoCause cause = GoCause(
        id: id,
        creatorID: creatorID,
        dateCreatedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
        name: name,
        goal: goal,
        why: why,
        who: who,
        resources: resources,
        charityURL: charityURL,
        actions: actions,
        admins: admins,
        imageURLs: [],
        followers: [creatorID],
        followerCount: 1,
        forumPostCount: 0,
        videoLink: videoLink,
        monetized: monetized,
        revenue: 0,
        approved: false);

    if (img1 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img1,
        storageBucket: 'causes',
        folderName: cause.id!,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs!.add(imgURL);
    }
    if (img2 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img2,
        storageBucket: 'causes',
        folderName: cause.id!,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs!.add(imgURL);
    }
    if (img3 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img3,
        storageBucket: 'causes',
        folderName: cause.id!,
        fileName: getRandomString(10) + ".png",
      );
      cause.imageURLs!.add(imgURL);
    }

    mail(id: id);

    await causeRef.doc(cause.id).set(cause.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future editCause(
      {String? causeID,
      String? name,
      String? goal,
      String? why,
      String? who,
      String? resources,
      String? charityURL,
      String? videoLink,
      dynamic img1,
      dynamic img2,
      dynamic img3,
      bool? monetized,
      required bool img1Changed,
      required bool img2Changed,
      required bool img3Changed}) async {
    //print("1");
    DocumentReference cause = causeRef.doc(causeID);
    //print(cause);

    //delete all the previous images to save space
    GoCause causeR = await (getCauseByID(causeID) as FutureOr<GoCause>);
    //print(causeR);
    List? imageURLs = (causeR.imageURLs != null) ? causeR.imageURLs : [];
    List newImageURLs = [];

    //deleting all of the image urls of changed images
    if (img1Changed) {
      FirebaseStorage.instance.refFromURL(imageURLs![0]).delete();
    } else {
      if (img1 != null) {
        newImageURLs.add(imageURLs![0]);
      }
    }
    if (img2Changed && imageURLs!.length > 1) {
      FirebaseStorage.instance.refFromURL(imageURLs[1]).delete();
    } else {
      if (img2 != null && imageURLs!.length > 1) {
        newImageURLs.add(imageURLs[1]);
      }
    }
    if (img3Changed && imageURLs!.length > 2) {
      FirebaseStorage.instance.refFromURL(imageURLs[2]).delete();
    } else {
      if (img3 != null && imageURLs!.length > 2) {
        newImageURLs.add(imageURLs[2]);
      }
    }

    //now upload the new images

    if (img1Changed && img1 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img1,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      newImageURLs.add(imgURL);
    }
    if (img2Changed && img2 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img2,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      print(imgURL);
      newImageURLs.add(imgURL);
    }
    if (img3Changed && img3 != null) {
      String imgURL = await FirestoreImageUploader().uploadImage(
        img: img3,
        storageBucket: 'causes',
        folderName: cause.id,
        fileName: getRandomString(10) + ".png",
      );
      newImageURLs.add(imgURL);
    }

    if (img1 == null && img2 == null && img3 == null) {
      print(newImageURLs);
      cause.update({
        "name": name,
        "goal": goal,
        "why": why,
        "resources": resources,
        "charityURL": charityURL,
        "videoLink": videoLink,
        "monetized": monetized,
      });
    } else {
      cause.update({
        "name": name,
        "goal": goal,
        "why": why,
        "resources": resources,
        "charityURL": charityURL,
        "imageURLs": newImageURLs,
        "videoLink": videoLink,
        "monetized": monetized
      });
    }
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
