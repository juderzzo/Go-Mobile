import 'package:flutter/material.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/ui/pages/auth_pages/signin_page.dart';
import 'package:go/ui/pages/home_page.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';

enum AuthStatus {
  unknown,
  notSignedIn,
  signedIn,
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.unknown;

  @override
  void initState() {
    super.initState();
    AuthService().getCurrentUserID().then((res) {
      if (res == null) {
        authStatus = AuthStatus.notSignedIn;
      } else {
        authStatus = AuthStatus.signedIn;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.unknown:
        return Center(
          child: CustomCircleProgressIndicator(),
        );
      case AuthStatus.notSignedIn:
        return SignInPage(); //SignUpPage();
      case AuthStatus.signedIn:
        return HomePage(); //HomePage();
    }
  }
}
