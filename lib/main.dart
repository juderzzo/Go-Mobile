import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:go/ui/bottom_sheets/setup_bottom_sheet_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/theme_config.dart';

void main() async {
  // Register all the models and services before the app starts
  await ThemeManager.initialise();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-9312496461922231~5212290852');

  setupLocator();
  setupBottomSheetUI();
  setupSnackBarUi();

  //Get User Instance if Previously Logged In
  await Future.delayed(Duration(seconds: 2));
  await setupAuthListener();

  runApp(GoApp());
}

Future<void> setupAuthListener() async {
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();
  UserDataService _userDataService = locator<UserDataService>();
  FirebaseAuth.instance.authStateChanges().listen((event) async {
    if (event != null) {
      _reactiveUserService.updateUserLoggedIn(true);
      GoUser user = await _userDataService.getGoUserByID(event.uid);
      _reactiveUserService.updateUser(user);
    }
  });
}

void setupSnackBarUi() {
  final service = locator<SnackbarService>();
  service.registerSnackbarConfig(
    SnackbarConfig(
      backgroundColor: Colors.red,
      textColor: Colors.white,
      mainButtonTextColor: Colors.black,
    ),
  );
}

class GoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      lightTheme: regularTheme,
      darkTheme: darkTheme,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Go App',
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: Routes.RootViewRoute,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
