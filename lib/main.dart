import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go/services/dialog_service.dart';
import 'package:go/services/navigation_service.dart';
import 'package:go/ui/pages/root_page.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';
import 'routes/router.dart';

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
      home: RootPage(),
      routes: <String, WidgetBuilder>{
        '/root': (BuildContext context) => RootPage(),
      },
      onGenerateRoute: generateRoute,
    );
  }
}
