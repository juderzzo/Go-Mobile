import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/user_data_service.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserDataService? _userDataService = locator<UserDataService>();
  CustomDialogService? _customDialogService = locator<CustomDialogService>();

  //AUTH STATE
  Future<bool> isLoggedIn() async {
    User? user = firebaseAuth.currentUser;
    return user != null;
  }

  Future<String?> getCurrentUserID() async {
    User? user = firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<String?> signOut() async {
    await firebaseAuth.signOut();
    User? user = firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  //Forgot Password

  void sendPasswordResetEmail(email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //SIGN IN & REGISTRATION

  Future signUpWithEmail({required String email, required String password}) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      credential.user!.sendEmailVerification();
      return credential.user != null;
    } catch (e) {
      //return e.message;
    }
  }

  Future signInWithEmail({required String email, required String password}) async {
    try {
      print("1");
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          String? uid = await getCurrentUserID();
          bool exists = await (_userDataService!.checkIfUserExists(uid) as FutureOr<bool>);
          if (!exists) {
            print("user doesnt exist");
            _userDataService!.createGoUser(id: uid!, fbID: null, googleID: null, email: email, phoneNo: null);
          }
          return true;
        } else {
          return "Email Confirmation Required";
        }
      }
    } catch (e) {
      //print(e.message);
      //return e.message;
    }
  }

  Future loginWithFacebook() async {
    // try {
    //   //Acquire FB access token and data
    //   final AccessToken accessToken = await FacebookAuth.instance.login(permissions: ['email']);
    //   final Map<String, dynamic> fbUserData = await FacebookAuth.instance.getUserData();
    //   final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(accessToken.token);
    //
    //   //Authenticate token with Firebase
    //   try {
    //     UserCredential credential = await firebaseAuth.signInWithCredential(oAuthCredential);
    //     if (credential.user != null) {
    //       //Create New User or Find Existing One
    //       bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);
    //
    //       if (userExists) {
    //         return true;
    //       } else {
    //         //Create New User
    //         var res = await _userDataService.createGoUser(
    //           id: credential.user.uid,
    //           fbID: accessToken.userId,
    //           googleID: null,
    //           email: fbUserData['email'],
    //           phoneNo: null,
    //         );
    //         if (res is String) {
    //           _snackbarService.showSnackbar(
    //             title: 'Login Error',
    //             message: res,
    //             duration: Duration(seconds: 5),
    //           );
    //           return false;
    //         } else {
    //           return true;
    //         }
    //       }
    //     }
    //   } catch (e) {
    //     _snackbarService.showSnackbar(
    //       title: 'Login Error',
    //       message: e.message,
    //       duration: Duration(seconds: 5),
    //     );
    //   }
    // } on FacebookAuthException catch (e) {
    //   String errorMessage = "";
    //   switch (e.errorCode) {
    //     case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
    //       errorMessage = "Login operation already in progress...";
    //       break;
    //     case FacebookAuthErrorCode.CANCELLED:
    //       errorMessage = "Facebook login cancelled";
    //       break;
    //     case FacebookAuthErrorCode.FAILED:
    //       errorMessage = "Facebook login failed";
    //       break;
    //   }
    //   _snackbarService.showSnackbar(
    //     title: 'Facebook Login Error',
    //     message: errorMessage,
    //     duration: Duration(seconds: 5),
    //   );
    // }
  }

  Future loginWithApple() async {
    // final AuthorizationResult result = await AppleSignIn.performRequests([
    //   AppleIdRequest(requestedScopes: [Scope.email])
    // ]);
    // if (result.status == AuthorizationStatus.authorized) {
    //   final AppleIdCredential appleIdCredential = result.credential;
    //   OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    //   final AuthCredential appleIDCredential = oAuthProvider.credential(
    //     idToken: String.fromCharCodes(appleIdCredential.identityToken),
    //     accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    //   );
    //   try {
    //     UserCredential credential = await firebaseAuth.signInWithCredential(appleIDCredential);
    //     if (credential.user != null) {
    //       //Create New User or Find Existing One
    //       bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);
    //
    //       if (userExists) {
    //         return true;
    //       } else {
    //         //Create New User
    //         var res = await _userDataService.createGoUser(
    //           id: credential.user.uid,
    //           fbID: null,
    //           googleID: null,
    //           email: null,
    //           phoneNo: null,
    //         );
    //         if (res is String) {
    //           _snackbarService.showSnackbar(
    //             title: 'Login Error',
    //             message: res,
    //             duration: Duration(seconds: 5),
    //           );
    //           return false;
    //         } else {
    //           return true;
    //         }
    //       }
    //     }
    //   } catch (e) {
    //     _snackbarService.showSnackbar(
    //       title: 'Login Error',
    //       message: e.message,
    //       duration: Duration(seconds: 5),
    //     );
    //     return false;
    //   }
    // } else if (result.status == AuthorizationStatus.cancelled) {
    //   _snackbarService.showSnackbar(
    //     title: 'Login Error',
    //     message: "Apple Sign In Cancelled",
    //     duration: Duration(seconds: 5),
    //   );
    //   return false;
    // } else {
    //   _snackbarService.showSnackbar(
    //     title: 'Login Error',
    //     message: "There was an issue signing in. Please try again.",
    //     duration: Duration(seconds: 5),
    //   );
    //   return false;
    // }
  }

  Future loginWithGoogle() async {
    // GoogleSignIn googleSignIn = GoogleSignIn(
    //   scopes: <String>[
    //     'email',
    //   ],
    // );
    // GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    // if (googleAccount == null) {
    //   _snackbarService.showSnackbar(
    //     title: 'Login Error',
    //     message: 'Cancelled Google Sign In',
    //     duration: Duration(seconds: 5),
    //   );
    //   return;
    // }
    // GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
    // AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    // try {
    //   UserCredential credential = await firebaseAuth.signInWithCredential(authCredential);
    //   if (credential.user != null) {
    //     //Create New User or Find Existing One
    //     bool userExists = await _userDataService.checkIfUserExists(credential.user.uid);
    //     if (userExists) {
    //       return true;
    //     } else {
    //       //Create New User
    //       var res = await _userDataService.createGoUser(
    //         id: credential.user.uid,
    //         fbID: null,
    //         googleID: googleAuth.idToken,
    //         email: null,
    //         phoneNo: null,
    //       );
    //       if (res is String) {
    //         _snackbarService.showSnackbar(
    //           title: 'Login Error',
    //           message: res,
    //           duration: Duration(seconds: 5),
    //         );
    //         return false;
    //       } else {
    //         return true;
    //       }
    //     }
    //   }
    // } catch (e) {
    //   _snackbarService.showSnackbar(
    //     title: 'Login Error',
    //     message: e.message,
    //     duration: Duration(seconds: 5),
    //   );
    //   return false;
    // }
  }
}
