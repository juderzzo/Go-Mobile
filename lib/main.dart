import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';
import 'package:go/ui/pages/auth_pages/signin_page.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compound',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 9, 202, 172),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      home: SignInPage(),
      onGenerateRoute: generateRoute,
    );
  }
}
