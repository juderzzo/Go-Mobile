import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/list_builders/notifications/list_notifications.dart';
import 'package:stacked/stacked.dart';

import 'notifications_view_model.dart';

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => NotificationsViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor(),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  _Head(
                    navigateBack: () => model.navigateBack(),
                  ),
                  Expanded(
                    child: ListNotifications(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Head extends StatelessWidget {
  final VoidCallback navigateBack;
  _Head({required this.navigateBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: navigateBack,
                icon: Icon(FontAwesomeIcons.angleLeft, color: appFontColor(), size: 24),
              ),
              Text(
                "Activity",
                style: TextStyle(
                  color: appFontColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
