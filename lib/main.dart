import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/ui/bottom_sheets/setup_bottom_sheet_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/locator.dart';
import 'app/theme_config.dart';

void main() async {
  // Register all the models and services before the app starts
  await ThemeManager.initialise();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  setupBottomSheetUI();
  setupSnackBarUi();
  runApp(GoApp());
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
        onGenerateRoute: GoRouter().onGenerateRoute,
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}
