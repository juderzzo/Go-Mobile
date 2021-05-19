import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/dialogs/custom_dialog_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserDataService _userDataService = locator<UserDataService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
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
  Future<bool> signUpWithEmail({required String email, required String password}) async {
    bool res = true;
    String? error;

    UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).catchError((e) {
      error = e.message;
      res = false;
    });

    if (error != null) {
      _customDialogService.showErrorDialog(description: error!);
      return res;
    }

    credential.user!.sendEmailVerification();
    GoUser user = GoUser().generateNewUser(id: credential.user!.uid);
    user.email = email;
    await _userDataService.createGoUser(user: user);

    return res;
  }

  //Email
  Future<bool> signInWithEmail({required String email, required String password}) async {
    bool signedIn = false;
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      signedIn = true;
    }).catchError((error) {
      _customDialogService.showErrorDialog(description: error.message);
    });
    return signedIn;
  }

  //Facebook
  Future<bool> signInWithFacebook() async {
    bool signedIn = false;
    final FacebookAuth fbAuth = FacebookAuth.instance;
    final LoginResult result = await fbAuth.login(permissions: ['email']);
    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(credential).then((val) async {
          signedIn = true;
        }).catchError((e) {
          _customDialogService.showErrorDialog(description: e.message);
        });
        break;
      case LoginStatus.cancelled:
        _customDialogService.showErrorDialog(description: "Cancelled Facebook Sign In");
        break;
      case LoginStatus.failed:
        _customDialogService.showErrorDialog(description: "There was an Issue Signing Into Facebook");
        break;
      case LoginStatus.operationInProgress:
        // TODO: Handle this case.
        break;
    }
    return signedIn;
  }

  //Apple
  Future<bool> signInWithApple() async {
    bool signedIn = true;
    await FirebaseAuthOAuth().openSignInFlow("apple.com", ["email"]).then((user) async {
      print('apple sign in with user: ${user!.uid}');
      print(user.email);
    }).catchError((error) {
      _customDialogService.showErrorDialog(description: error.message);
      signedIn = false;
    });
    return signedIn;
  }

  Future<bool> signInWithGoogle() async {
    bool signedIn = false;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    await _googleSignIn.signIn().then((googleAccount) async {
      await googleAccount!.authentication.then((googleAuth) async {
        AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential).then((val) async {
          signedIn = true;
        }).catchError((e) {
          _customDialogService.showErrorDialog(description: e.message);
        });
      });
    }).catchError((e) {
      _customDialogService.showErrorDialog(description: e.toString());
      print(e.message);
    });
    return signedIn;
  }

  Future<bool> completeUserSignIn() async {
    bool completedSignIn = true;
    String? uid = await getCurrentUserID();
    if (uid != null) {
      bool? userExists = await _userDataService.checkIfUserExists(id: uid);
      if (userExists == null) {
        _customDialogService.showErrorDialog(description: "Unknown error logging in. Please try again.");
        return false;
      } else if (userExists) {
        GoUser user = await _userDataService.getGoUserByID(uid);
        _reactiveUserService.updateUser(user);
        _reactiveUserService.updateUserLoggedIn(true);

        ///CHECK IF USER ONBOARDED
        if (user.onboarded == null || !user.onboarded!) {
          _navigationService.replaceWith(Routes.OnboardingViewRoute);
        } else {
          _navigationService.replaceWith(Routes.AppBaseViewRoute);
        }
      } else {
        ///CREATE NEW USER
        GoUser user = GoUser().generateNewUser(id: uid);
        bool createdUser = await _userDataService.createGoUser(user: user);
        if (createdUser) {
          _reactiveUserService.updateUser(user);
          _reactiveUserService.updateUserLoggedIn(true);
          _navigationService.replaceWith(Routes.OnboardingViewRoute);
        } else {
          _customDialogService.showErrorDialog(description: "Unknown error logging in. Please try again.");
          return false;
        }
      }
    }

    return completedSignIn;
  }
}
