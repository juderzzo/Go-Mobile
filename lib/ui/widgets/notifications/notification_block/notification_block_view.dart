import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/enums/notifcation_type.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/notifications/notification_block/notification_block_view_model.dart';
import 'package:stacked/stacked.dart';

class NotificationBlockView extends StatelessWidget {
  final GoNotification notification;
  NotificationBlockView({
    @required this.notification,
  });

  Widget notifIcon() {
    return Icon(
      notification.type == NotificationType.userFollow.toString() || notification.type == NotificationType.causeFollow.toString()
          ? FontAwesomeIcons.user
          : notification.type == NotificationType.postComment.toString() || notification.type == NotificationType.postCommentReply.toString()
              ? FontAwesomeIcons.comment
              : FontAwesomeIcons.bell,
      color: appFontColor(),
      size: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationBlockViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => NotificationBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.onTap(notifType: notification.type, data: notification.additionalData),
        child: Container(
          width: screenWidth(context),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(width: 0.5, color: appBorderColorAlt()),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                child: notifIcon(),
              ),
              horizontalSpaceTiny,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        notification.header,
                        style: TextStyle(
                          fontSize: 14,
                          color: appFontColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      notification.subHeader == null || notification.subHeader.isEmpty ? "View" : notification.subHeader,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
