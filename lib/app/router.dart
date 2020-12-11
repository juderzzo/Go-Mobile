import 'package:auto_route/auto_route_annotations.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view.dart';
import 'package:go/ui/views/auth/sign_up/sign_up_view.dart';
import 'package:go/ui/views/home/home_nav_view.dart';
import 'package:go/ui/views/root/root_view.dart';
import 'package:go/ui/views/settings/settings_view.dart';

///RUN "flutter pub run build_runner build" in Project Terminal to Generate Routes
@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: RootView, initial: true, name: "RootViewRoute"),
    MaterialRoute(page: SignUpView, name: "SignUpViewRoute"),
    MaterialRoute(page: SignInView, name: "SignInViewRoute"),
    MaterialRoute(page: HomeNavView, name: "HomeNavViewRoute"),
    MaterialRoute(page: SettingsView, name: "SettingsViewRoute"),
  ],
)
class $GoRouter {}
