import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_notification_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/notifications/notification_block/notification_block_view.dart';
import 'package:stacked/stacked.dart';

import 'list_notifications_model.dart';

class ListNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListNotificationsModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListNotificationsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "No Recent Activity Found",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appFontColor(),
                        ),
                        CustomText(
                          text: "Check Back Here Later",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: appFontColor(),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor(),
                  child: RefreshIndicator(
                    onRefresh: model.refreshData,
                    backgroundColor: appBackgroundColor(),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: model.scrollController,
                      key: PageStorageKey(model.listKey),
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      itemCount: model.dataResults.length + 1,
                      itemBuilder: (context, index) {
                        if (index < model.dataResults.length) {
                          GoNotification notification;
                          notification = GoNotification.fromMap(model.dataResults[index].data()!);
                          return NotificationBlockView(
                            notification: notification,
                          );
                        } else {
                          if (model.moreDataAvailable) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              model.loadAdditionalData();
                            });
                            return Align(
                              alignment: Alignment.center,
                              child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
                            );
                          }
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
    );
  }
}
