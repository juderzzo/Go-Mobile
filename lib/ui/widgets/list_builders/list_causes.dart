import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause_block/cause_block_view.dart';

class ListCauses extends StatelessWidget {
  final List causesResults;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  ListCauses(
      {@required this.refreshData,
      @required this.causesResults,
      @required this.pageStorageKey,
      @required this.scrollController});

  Widget listPosts() {
    return RefreshIndicator(
      onRefresh: refreshData,
      backgroundColor: appBackgroundColor(),
      child: ListView.builder(
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
          GoCause cause = GoCause.fromMap(causesResults[index].data());
          return CauseBlockView(cause: cause);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      color: appBackgroundColor(),
      child: listPosts(),
    );
  }
}
