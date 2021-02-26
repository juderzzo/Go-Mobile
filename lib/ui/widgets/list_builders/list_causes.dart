import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/causes/cause_block/cause_block_view.dart';

class ListCauses extends StatelessWidget {
  final List causesResults;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  ListCauses({@required this.refreshData, @required this.causesResults, @required this.pageStorageKey, @required this.scrollController});

  Widget listCauses() {
    return RefreshIndicator(
      onRefresh: refreshData,
      backgroundColor: appBackgroundColor(),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        key: pageStorageKey,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 4.0,
          bottom: 4.0,
        ),
        itemCount: causesResults.length,
        itemBuilder: (context, index) {
          GoCause cause;
          bool displayBottomBorder = true;

          ///GET CAUSE OBJECT
          if (causesResults[index] is DocumentSnapshot) {
            cause = GoCause.fromMap(causesResults[index].data());
          } else {
            cause = causesResults[index];
          }

          ///DISPLAY BOTTOM BORDER
          if (causesResults.last == causesResults[index]) {
            displayBottomBorder = false;
          }

          if (cause.approved) {
            return CauseBlockView(
              cause: cause,
              displayBottomBorder: displayBottomBorder,
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      color: appBackgroundColor(),
      child: listCauses(),
    );
  }
}
