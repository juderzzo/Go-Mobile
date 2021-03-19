import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/settings/settings_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicAppBar(
          title: "Settings",
          showBackButton: true,
        ),
        body: Container(
          color: appBackgroundColor(),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            children: [
              CustomSwitchButton(
                onTap: () => model.toggleDarkMode(),
                fontColor: appFontColor(),
                fontSize: 16,
                text: "Dark Mode",
                isActive: model.isDarkMode(),
                showBottomBorder: true,
              ),
              CustomFlatButton(
                onTap: model.enableNotifications,
                fontColor: appFontColor(),
                fontSize: 16,
                text: "Enable Notifications",
                showBottomBorder: true,
              ),

              
              CustomFlatButton(
                onTap: () {
                  print("tapped");
                  model.signOut(context);
                },
                fontColor: Colors.red,
                fontSize: 16,
                text: "Log Out",
                showBottomBorder: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
