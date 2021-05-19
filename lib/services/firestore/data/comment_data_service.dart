import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:stacked_services/stacked_services.dart';

class CommentDataService {
  final SnackbarService? _snackbarService = locator<SnackbarService>();
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection("comments");
  final CollectionReference postsRef = FirebaseFirestore.instance.collection("posts");
  //CREATE
  Future<String?> sendComment(String? parentID, String? postAuthorID, GoForumPostComment comment) async {
    String? error;
    await commentsRef.doc(parentID).collection("comments").doc(comment.timePostedInMilliseconds.toString()).set(comment.toMap()).catchError((e) {
      print(e);
      //error = e.details;
    });
    DocumentSnapshot snapshot = await postsRef.doc(parentID).get();
    GoForumPost post = GoForumPost.fromMap(snapshot.data()!);
    post.commentCount = post.commentCount! + 1;
    await postsRef.doc(parentID).update(post.toMap()).catchError((e) {
      error = e.details;
    });
    if (error == null && postAuthorID != comment.senderUID) {
      //NotificationDataService().sendPostCommentNotification(comment.postID, postAuthorID, comment.senderUID, comment.message);
    }
    return error;
  }

  Future<String?> replyToComment(String? parentID, String? originaCommenterUID, String originalCommentID, GoForumPostComment comment) async {
    String? error;
    DocumentSnapshot snapshot = await commentsRef.doc(parentID).collection("comments").doc(originalCommentID).get();
    print(snapshot.data());
    GoForumPostComment originalComment = GoForumPostComment.fromMap(snapshot.data()!);

    List replies = originalComment.replies!.toList(growable: true);
    replies.add(comment.toMap());
    originalComment.replies = replies;
    originalComment.replyCount = originalComment.replyCount! + 1;
    await commentsRef.doc(parentID).collection("comments").doc(originalCommentID).update(originalComment.toMap()).catchError((e) {
      error = e.details;
    });
    if (error == null && originaCommenterUID != comment.senderUID) {
      //NotificationDataService().sendPostCommentReplyNotification(comment.postID, originaCommenterUID, originalCommentID, comment.senderUID, comment.message);
    }
    return error;
  }

  Future<String?> deleteComment(String? parentID, String? commentID) async {
    String? error;
    DocumentSnapshot snapshot3 = await commentsRef.doc(parentID).collection("comments").doc(commentID).get();

    GoForumPostComment comment = GoForumPostComment.fromMap(snapshot3.data()!);
    if (comment.imageURL != null) {
      FirebaseStorage.instance.ref("comments/$parentID/$commentID").delete();
    }
    await commentsRef.doc(parentID).collection("comments").doc(commentID).delete().catchError((e) {
      error = e.toString();
    });
    DocumentSnapshot snapshot = await postsRef.doc(parentID).get();
    GoForumPost post = GoForumPost.fromMap(snapshot.data()!);
    post.commentCount = post.commentCount! - 1;
    await postsRef.doc(parentID).update(post.toMap()).catchError((e) {
      error = e.details;
    });
    return error;
  }

  Future<String?> deleteReply(String parentID, String originalCommentID, GoForumPostComment comment) async {
    String? error;
    DocumentSnapshot snapshot = await commentsRef.doc(parentID).collection("comments").doc(originalCommentID).get();
    GoForumPostComment originalComment = GoForumPostComment.fromMap(snapshot.data()!);
    List replies = originalComment.replies!.toList(growable: true);
    int replyIndex = replies.indexWhere((element) => element['message'] == comment.message);
    replies.removeAt(replyIndex);
    originalComment.replies = replies;
    originalComment.replyCount = originalComment.replyCount! - 1;
    await commentsRef.doc(parentID).collection("comments").doc(originalCommentID).update(originalComment.toMap()).catchError((e) {
      error = e.details;
    });
    return error;
  }

  ///QUERY DATA
  //Load Comments Created
  Future<List<DocumentSnapshot>> loadComments({
    required String? postID,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = commentsRef.doc(postID).collection('comments').orderBy('timePostedInMilliseconds', descending: true).limit(resultsLimit);

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
  Future<List<DocumentSnapshot>> loadAdditionalComments({
    required String? postID,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    query = commentsRef
        .doc(postID)
        .collection('comments')
        .orderBy('timePostedInMilliseconds', descending: true)
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
}
