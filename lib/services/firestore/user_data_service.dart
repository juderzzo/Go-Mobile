import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/app/locator.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:go/utils/firestore_image_uploader.dart';
import 'package:stacked_services/stacked_services.dart';

class UserDataService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  SnackbarService _snackbarService = locator<SnackbarService>();
  //AuthService _authService = locator<AuthService>();

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

    await userRef.doc(id).update({"onboarded": false});
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

  Future getGoUserByUsername(String username) async {
    GoUser user;
    QuerySnapshot querySnapshot = await userRef.where("username", isEqualTo: username).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Map<String, dynamic> docData = doc.data();
      user = GoUser.fromMap(docData);
    }
    return user;
  }

  Future addPost(String id, String postID) async {
    GoUser user = await getGoUserByID(id);
    user.posts.add(postID);
    updateGoUser(user);
  }

  Future removePost(String id, String postID) async {
    GoUser user = await getGoUserByID(id);
    user.posts.remove(postID);
    updateGoUser(user);
  }

  Future updateGoUser(GoUser user) async {
    await userRef.doc(user.id).update(user.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future updateUserOnboardStatus(String id) async {
    await userRef.doc(id).update({
      "onboarded": true,
    }).catchError((e) {
      return e.message;
    });
  }

  Future<bool> updateCheckedItems(String id, String uid) async {
    GoUser user;
    DocumentSnapshot snapshot = await userRef.doc(uid).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      user = GoUser.fromMap(snapshotData);
    }
    if (user.checks.length == null) {
      user.checks = [];
    }

    if (!user.checks.contains(id)) {
      user.checks.add(id);
      print(user.checks);
      updateGoUser(user);
    }

    return true;
  }

  Future<bool> isChecked(String id, String uid) async {
    GoUser user;
    DocumentSnapshot snapshot = await userRef.doc(uid).get().catchError((e) {
      return e.message;
    });
    if (snapshot.exists) {
      Map<String, dynamic> snapshotData = snapshot.data();
      user = GoUser.fromMap(snapshotData);
    }
    if (user.checks.length == null) {
      return false;
    }
    return user.checks.contains(id);
  }

  Future updateGoUserName(String id, String username) async {
    bool exists = await checkIfUserExists(id);
    if (exists) {
      await userRef.doc(id).update({
        "username": username,
      }).catchError((e) {
        return e.message;
      });
    } else {
      print("does not exist");
    }
  }

  Future updateLikedPosts(String id, List likedPosts) async {
    await userRef.doc(id).update({
      "liked": likedPosts,
    }).catchError((e) {
      return e.message;
    });
  }

  Future updateGoUserBio(String id, String bio) async {
    await userRef.doc(id).update({
      "bio": bio,
    }).catchError((e) {
      return e.message;
    });
  }

  Future updateGoUsername(String id, String username) async {
    await userRef.doc(id).update({"username": username}).catchError((e) {
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

  Future updateUserMessageToken(String id, String messageToken) async {
    await userRef.doc(id).update({
      "messageToken": messageToken,
    }).catchError((e) {
      return e.message;
    });
  }

  //is Follwing
  Future<bool> isFollowing(String uid) async {
    AuthService _authService = locator<AuthService>();
    String id = await _authService.getCurrentUserID();
    DocumentSnapshot user = await userRef.doc(id).get();
    return user.data()['following'].contains(uid);
  }

  Future followUnfollowUser(String uid) async {
    AuthService _authService = locator<AuthService>();
    String id = await _authService.getCurrentUserID();
    if (await isFollowing(uid)) {
      DocumentSnapshot user = await userRef.doc(id).get();
      List following = user.data()['following'];
      following.remove(uid);
      userRef.doc(id).update({'following': following, 'followingCount': following.length});

      DocumentSnapshot other = await userRef.doc(uid).get();
      List followers = other.data()['followers'];
      followers.remove(id);
      userRef.doc(uid).update({
        'followers': followers,
        'followersCount': followers.length,
      });
    } else {
      DocumentSnapshot user = await userRef.doc(id).get();
      List following = user.data()['following'];
      following.add(uid);
      userRef.doc(id).update({'following': following, 'followingCount': following.length});

      DocumentSnapshot other = await userRef.doc(uid).get();
      List followers = other.data()['followers'];
      followers.add(id);
      userRef.doc(uid).update({
        'followers': followers,
        'followersCount': followers.length,
      });
    }
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

  Future likeUnlikePost(String id, String postID) async {
    //if they dont have a like list you have to make one

    DocumentSnapshot user = await userRef.doc(id).get();
    List liked = user.data()['liked'];

    if (liked.contains(postID)) {
      liked.remove(postID);
    } else {
      liked.add(postID);
    }
    userRef.doc(id).update({'liked': liked});
  }
}
