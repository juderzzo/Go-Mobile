import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthService {
  UserDataService _userDataService = locator<UserDataService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //AUTH STATE
  Future<bool> isLoggedIn() async {
    User user = firebaseAuth.currentUser;
    return user != null;
  }

  Future<String> getCurrentUserID() async {
    User user = firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<String> signOut() async {
    await firebaseAuth.signOut();
    User user = firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  //SIGN IN & REGISTRATION

  Future signUpWithEmail({@required String email, @required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      credential.user.sendEmailVerification();
      return credential.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signInWithEmail({@required String email, @required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        if (credential.user.emailVerified) {
          return true;
        } else {
          return "Email Confirmation Required";
        }
      }
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> sendPasswordResetEmail(email) async {
      try {
        //print(email);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } catch (e) {
        print('Please enter an email associated with an account');
        return false;
      }
      return true;
    }
  


  

  Future loginWithFacebook() async {
    try {
      //Acquire FB access token and data
      final AccessToken accessToken = await FacebookAuth.instance.login(permissions: ['email']);
      final Map<String, dynamic> fbUserData = await FacebookAuth.instance.getUserData();
      final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(accessToken.token);

      //Authenticate token with Firebase
      try {
        UserCredential credential = await firebaseAuth.signInWithCredential(oAuthCredential);
        if (credential.user != null) {
          //Create New User or Find Existing One
          bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);

          if (userExists) {
            return true;
          } else {
            //Create New User
            var res = await _userDataService.createGoUser(
              id: credential.user.uid,
              fbID: accessToken.userId,
              googleID: null,
              email: fbUserData['email'],
              phoneNo: null,
            );
            if (res is String) {
              _snackbarService.showSnackbar(
                title: 'Login Error',
                message: res,
                duration: Duration(seconds: 5),
              );
              return false;
            } else {
              return true;
            }
          }
        }
      } catch (e) {
        _snackbarService.showSnackbar(
          title: 'Login Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
    } on FacebookAuthException catch (e) {
      String errorMessage = "";
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          errorMessage = "Login operation already in progress...";
          break;
        case FacebookAuthErrorCode.CANCELLED:
          errorMessage = "Facebook login cancelled";
          break;
        case FacebookAuthErrorCode.FAILED:
          errorMessage = "Facebook login failed";
          break;
      }
      _snackbarService.showSnackbar(
        title: 'Facebook Login Error',
        message: errorMessage,
        duration: Duration(seconds: 5),
      );
    }
  }

  Future loginWithApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email])
    ]);
    if (result.status == AuthorizationStatus.authorized) {
      final AppleIdCredential appleIdCredential = result.credential;
      OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      final AuthCredential appleIDCredential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken),
        accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
      );
      try {
        UserCredential credential = await firebaseAuth.signInWithCredential(appleIDCredential);
        if (credential.user != null) {
          //Create New User or Find Existing One
          bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);

          if (userExists) {
            return true;
          } else {
            //Create New User
            var res = await _userDataService.createGoUser(
              id: credential.user.uid,
              fbID: null,
              googleID: null,
              email: null,
              phoneNo: null,
            );
            if (res is String) {
              _snackbarService.showSnackbar(
                title: 'Login Error',
                message: res,
                duration: Duration(seconds: 5),
              );
              return false;
            } else {
              return true;
            }
          }
        }
      } catch (e) {
        _snackbarService.showSnackbar(
          title: 'Login Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
        return false;
      }
    } else if (result.status == AuthorizationStatus.cancelled) {
      _snackbarService.showSnackbar(
        title: 'Login Error',
        message: "Apple Sign In Cancelled",
        duration: Duration(seconds: 5),
      );
      return false;
    } else {
      _snackbarService.showSnackbar(
        title: 'Login Error',
        message: "There was an issue signing in. Please try again.",
        duration: Duration(seconds: 5),
      );
      return false;
    }
  }

  Future loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],
    );
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount == null) {
      _snackbarService.showSnackbar(
        title: 'Login Error',
        message: 'Cancelled Google Sign In',
        duration: Duration(seconds: 5),
      );
      return;
    }
    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    try {
      UserCredential credential = await firebaseAuth.signInWithCredential(authCredential);
      if (credential.user != null) {
        //Create New User or Find Existing One
        bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);
        if (userExists) {
          return true;
        } else {
          //Create New User
          var res = await _userDataService.createGoUser(
            id: credential.user.uid,
            fbID: null,
            googleID: googleAuth.idToken,
            email: null,
            phoneNo: null,
          );
          if (res is String) {
            _snackbarService.showSnackbar(
              title: 'Login Error',
              message: res,
              duration: Duration(seconds: 5),
            );
            return false;
          } else {
            return true;
          }
        }
      }
    } catch (e) {
      _snackbarService.showSnackbar(
        title: 'Login Error',
        message: e.message,
        duration: Duration(seconds: 5),
      );
      return false;
    }
  }

  //ACCOUNT LINKING
  // Future<String> linkFacebookAccount(LoginResult result) async {
  //   String error;
  //   bool hasFBAccountConnected = false;
  //   User user = firebaseAuth.currentUser;
  //   user.providerData.forEach((userInfo) async {
  //     if (userInfo.providerId == "facebook.com") {
  //       hasFBAccountConnected = true;
  //       String fbID = await FacebookGraphAPI().getUserID(result.accessToken.token);
  //       if (userInfo.uid == fbID) {
  //         await WebblenUserData().setFBAccessToken(user.uid, result.accessToken.token);
  //       } else {
  //         error = "This Account is Already Associated with a FB Account";
  //       }
  //     }
  //   });
  //   if (!hasFBAccountConnected) {
  //     final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
  //     await user.linkWithCredential(credential).then((res) {
  //       WebblenUserData().setFBAccessToken(user.uid, result.accessToken.token);
  //     }).catchError((e) {
  //       error = e.code;
  //     });
  //   }
  //   return error;
  // }
  //
  // Future<String> linkYoutubeAccount(GoogleSignInAuthentication googleAuth) async {
  //   String error;
  //   bool hasGoogleAccountConnected = false;
  //   User user = firebaseAuth.currentUser;
  //   user.providerData.forEach((userInfo) async {
  //     print(userInfo);
  //     if (userInfo.providerId == "google.com") {
  //       hasGoogleAccountConnected = true;
  //       // String fbID = await FacebookGraphAPI().getUserID(result.accessToken.token);
  //       // if (userInfo.uid == fbID) {
  //       //   await WebblenUserData().setFBAccessToken(user.uid, result.accessToken.token);
  //       // } else {
  //       //   error = "This Account is Already Associated with a FB Account";
  //       // }
  //     }
  //   });
  //   if (!hasGoogleAccountConnected) {
  //     final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  //     await user.linkWithCredential(credential).then((res) {
  //       WebblenUserData().setGoogleAccessTokenAndID(user.uid, googleAuth.accessToken, googleAuth.idToken);
  //     }).catchError((e) {
  //       error = e.code;
  //     });
  //   }
  //   return error;
  // }
}
