import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:stacked_services/stacked_services.dart';

class PostDataService {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');
  CollectionReference commentsRef = FirebaseFirestore.instance.collection("comments");
  SnackbarService? _snackbarService = locator<SnackbarService>();
  UserDataService? _userDataService = locator<UserDataService>();

  Future checkIfPostExists(String id) async {
    bool exists = false;
    DocumentSnapshot snapshot = await postRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      exists = true;
    }
    return exists;
  }

  updatePostby(GoForumPost post) async {
    await postRef.doc(post.id).update(post.toMap()).catchError((e) {
      print(e);
      return;
    });
  }

  Future updatePost({
    String? id,
    String? causeID,
    String? authorID,
    String? body,
    dynamic image,
    int? dateCreatedInMilliseconds,
    int? commentCount,
  }) async {
    ///print("image runype === ");
    //print(image.runtimeType);
    late GoForumPost post;
    String url = "";
    if (image.runtimeType == NetworkImage && image != null) {
      GoForumPost currentPost = await (getPostByID(id) as FutureOr<GoForumPost>);
      String? h = currentPost.imageID;
      post = GoForumPost(
        id: id,
        causeID: causeID,
        authorID: authorID,
        body: body,
        imageID: h,
        dateCreatedInMilliseconds: dateCreatedInMilliseconds,
        commentCount: commentCount,
      );
    } else if (image.runtimeType != NetworkImage && image.runtimeType != Null && image != null) {
      //see if you have to delete the old image

      Future<Null> onError(error) async {
        print("getting called");
        await FirestoreImageUploader().uploadImage(img: image, storageBucket: 'posts', folderName: causeID!, fileName: id!).then((v) async {
          print("WORKGIN");
          url = await FirebaseStorage.instance.ref('posts/$causeID/$id').getDownloadURL();
          //print(url);
        }).then(
          (value) {
            post = GoForumPost(
              id: id,
              causeID: causeID,
              authorID: authorID,
              body: body,
              imageID: url,
              dateCreatedInMilliseconds: dateCreatedInMilliseconds,
              commentCount: commentCount,
            );
          },
        ).then((value) async {
          await postRef.doc(post.id).set(post.toMap()).catchError((e) {
            return e.message;
          });
        });
      }

      onValue(String url) async {
        print("incorrectly");
        await FirebaseStorage.instance.ref('posts/$causeID/$id').delete().then((d) async {
          onError("");
        });
      }

      if (image != null) {
        await FirebaseStorage.instance.ref('posts/$causeID/$id').getDownloadURL().then((f) async {
          onValue(f);
        }, onError: onError);

        // url = await FirebaseStorage.instance
        //     .ref('posts/$causeID/$id')
        //     .getDownloadURL();

        print(url);

        post = GoForumPost(
          id: id,
          causeID: causeID,
          authorID: authorID,
          body: body,
          imageID: url,
          dateCreatedInMilliseconds: dateCreatedInMilliseconds,
          commentCount: commentCount,
        );
      }
    } else {
      //this means its just null
      await FirebaseStorage.instance.ref('posts/$causeID/$id').delete().then((value) => null, onError: (object) {
        print("nevermind");
      });

      post = GoForumPost(
        id: id,
        causeID: causeID,
        authorID: authorID,
        body: body,
        imageID: "",
        dateCreatedInMilliseconds: dateCreatedInMilliseconds,
        commentCount: commentCount,
      );
    }
    await postRef.doc(post.id).set(post.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future createPost({
    String? id,
    String? causeID,
    String? authorID,
    String? body,
    File? image,
    int? dateCreatedInMilliseconds,
    int? commentCount,
  }) async {
    String url = "";

    if (image != null) {
      await FirestoreImageUploader().uploadImage(img: image, storageBucket: 'posts', folderName: causeID!, fileName: id!).then((v) async {
        url = await FirebaseStorage.instance.ref('posts/$causeID/$id').getDownloadURL();
      });
    }

    GoForumPost post = GoForumPost(
      id: id,
      causeID: causeID,
      authorID: authorID,
      body: body,
      imageID: url,
      dateCreatedInMilliseconds: dateCreatedInMilliseconds,
      commentCount: commentCount,
    );
    await postRef.doc(post.id).set(post.toMap()).catchError((e) {
      return e.message;
    });
    print("post service");

    await _userDataService!.addPost(authorID, id).catchError((e) {
      print("post service2");
      print(e);
      return e.message;
    });
    print("post service2");
    return;
  }

  Future<GoForumPost> getPostByID(String? id) async {
    GoForumPost post = GoForumPost();
    DocumentSnapshot snapshot = await postRef.doc(id).get().catchError((e) {
      print(e.message);
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data()!;
      post = GoForumPost.fromMap(snapshotData);
    }
    return post;
  }

  Future checkpIfPostExists(id) async {
    DocumentSnapshot snapshot = await postRef.doc(id).get().catchError((e) {
      return e.message;
    });
    return snapshot.exists;
  }

  Future deletePost(id) async {
    //do the image

    GoForumPost post = await getPostByID(id);
    if (post.imageID != null && post.imageID!.length > 10) {
      FirebaseStorage.instance.refFromURL(post.imageID!).delete();
    }

    await commentsRef.doc(id).delete();
    await postRef.doc(id).delete();
    await _userDataService!.removePost(post.authorID, post.id);
  }

  ///QUERIES
  //Load Cause by Follower Count
  Future<List<DocumentSnapshot>> loadPosts({
    required String? causeID,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = postRef.where('causeID', isEqualTo: causeID).orderBy('dateCreatedInMilliseconds', descending: true).limit(resultsLimit);
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

  //Load Additional Causes by Follower Count
  Future<List<DocumentSnapshot>> loadAdditionalPosts({
    required String? causeID,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query =
        postRef.where('causeID', isEqualTo: causeID).orderBy('dateCreatedInMilliseconds', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);
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

  Future<List<DocumentSnapshot>> loadPostsByUser({
    required String? uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];

    Query query = postRef.where('authorID', isEqualTo: uid).orderBy('dateCreatedInMilliseconds', descending: true);

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

  Future<List<DocumentSnapshot>> loadAdditionalPostsByUser({
    required String? uid,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query =
        postRef.where('authorID', isEqualTo: uid).orderBy('dateCreatedInMilliseconds', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);
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

  Future<List<DocumentSnapshot>> loadPostsLikedByUser({
    required String? uid,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];

    Query query = postRef.where('likedBy', arrayContains: uid).orderBy('dateCreatedInMilliseconds', descending: true);

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

  Future<List<DocumentSnapshot>> loadAdditionalPostsLikedByUser({
    required String? uid,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query =
        postRef.where('likedBy', arrayContains: uid).orderBy('dateCreatedInMilliseconds', descending: true).startAfterDocument(lastDocSnap).limit(resultsLimit);
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
}
