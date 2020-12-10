import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/page_models/other_page_models/settings_page_model.dart';
import 'package:go/ui/widgets/buttons/settings_icon_button.dart';
import 'package:go/ui/widgets/navigation/app_bar/go_app_bar.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingsPageModel>.withConsumer(
      viewModelBuilder: () => SettingsPageModel(),
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
