import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/user/user_block/user_block_view.dart';
import 'package:stacked/stacked.dart';

import 'list_explore_users_model.dart';

class ListExploreUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListExploreUsersModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListExploreUsersModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  imageAssetName: "coding",
                  header: "No Users Found",
                  subHeader: "",
                  mainActionButtonTitle: "Create Cause",
                  mainAction: null,
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
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
                          GoUser user;
                          bool displayBottomBorder = true;

                          ///GET OBJECT
                          user = GoUser.fromMap(model.dataResults[index].data()!);

                          ///DISPLAY BOTTOM BORDER
                          if (model.dataResults.last == model.dataResults[index]) {
                            displayBottomBorder = false;
                          }
                          return UserBlockView(
                            user: user,
                            displayBottomBorder: displayBottomBorder,
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
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
    );
  }
}
