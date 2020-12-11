import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/settings/settings_view_model.dart';
import 'package:go/ui/widgets/buttons/settings_icon_button.dart';
import 'package:go/ui/widgets/navigation/app_bar/go_app_bar.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: GoAppBar().basicAppBar(
          title: "Settings",
          showBackButton: true,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              SettingsIconButton(
                onTap: null,
                iconData: FontAwesomeIcons.questionCircle,
                title: "Help/FAQ",
                color: Colors.black,
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              SettingsIconButton(
                onTap: () => model.signOut(context),
                iconData: FontAwesomeIcons.signOutAlt,
                title: "Log Out",
                color: Colors.red,
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
