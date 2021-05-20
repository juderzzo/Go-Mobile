import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/widgets/causes/cause_block/cause_block_view.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:stacked/stacked.dart';

import 'list_user_created_causes_model.dart';

class ListUserCreatedCauses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListUserCreatedCausesModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ListUserCreatedCausesModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  imageAssetName: "coding",
                  header: "This user has not created any causes",
                  subHeader: "Start a Movement and Create a Cause",
                  // mainActionButtonTitle: "Create Cause",
                  // mainAction: () => model.customNavigationService.navigateToCreateCauseView("new"),
                  secondaryActionButtonTitle: null,
                  secondaryAction: null,
                )
              : RefreshIndicator(
                  onRefresh: model.refreshData,
                  backgroundColor: appBackgroundColor(),
                  child: ListView.builder(
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
                        GoCause cause;
                        bool displayBottomBorder = true;

                        ///GET CAUSE OBJECT
                        cause = GoCause.fromMap(model.dataResults[index].data()!);

                        ///DISPLAY BOTTOM BORDER
                        if (model.dataResults.last == model.dataResults[index]) {
                          displayBottomBorder = false;
                        }
                        return CauseBlockView(
                          cause: cause,
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
    );
  }
}
