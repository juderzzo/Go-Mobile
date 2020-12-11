import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GoApp());
}

class GoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 9, 202, 172),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      initialRoute: Routes.RootViewRoute,
      onGenerateRoute: GoRouter().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
