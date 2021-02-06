import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:stacked_services/stacked_services.dart';

class PostDataService {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');
  CollectionReference commentsRef =
      FirebaseFirestore.instance.collection("comments");
  SnackbarService _snackbarService = locator<SnackbarService>();

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

  Future createPost({
    String id,
    String causeID,
    String authorID,
    String body,
    int dateCreatedInMilliseconds,
    int commentCount,
  }) async {
    GoForumPost post = GoForumPost(
      id: id,
      causeID: causeID,
      authorID: authorID,
      body: body,
      dateCreatedInMilliseconds: dateCreatedInMilliseconds,
      commentCount: commentCount,
    );
    await postRef.doc(post.id).set(post.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future getPostByID(String id) async {
    GoForumPost post;
    DocumentSnapshot snapshot = await postRef.doc(id).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      post = GoForumPost.fromMap(snapshotData);
    }
    return post;
  }

  Future deletePost(id) async {
    await commentsRef.doc(id).delete();
    await postRef.doc(id).delete();
  }

  ///QUERIES
  //Load Cause by Follower Count
  Future<List<DocumentSnapshot>> loadPosts({
    @required String causeID,
    @required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = postRef
        .where('causeID', isEqualTo: causeID)
        .orderBy('dateCreatedInMilliseconds', descending: true)
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
  Future<List<DocumentSnapshot>> loadAdditionalPosts({
    @required String causeID,
    @required DocumentSnapshot lastDocSnap,
    @required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = postRef
        .where('causeID', isEqualTo: causeID)
        .orderBy('dateCreatedInMilliseconds', descending: true)
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
