import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/user/user_block/user_block_view.dart';

class ListUsers extends StatelessWidget {
  final List userResults;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  ListUsers({required this.refreshData, required this.userResults, required this.pageStorageKey, required this.scrollController});

  Widget listUsers() {
    return RefreshIndicator(
      onRefresh: refreshData as Future<void> Function(),
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
        itemCount: userResults.length,
        itemBuilder: (context, index) {
          GoUser user;
          bool displayBottomBorder = true;

          ///GET USER OBJECT
          if (userResults[index] is Map) {
            user = GoUser.fromMap(userResults[index]);
          } else if (userResults[index] is DocumentSnapshot) {
            user = GoUser.fromMap(userResults[index].data());
          } else {
            user = userResults[index];
          }

          ///DISPLAY BOTTOM BORDER
          if (userResults.last == userResults[index]) {
            displayBottomBorder = false;
          }
          return UserBlockView(
            user: user,
            displayBottomBorder: displayBottomBorder,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      color: appBackgroundColor(),
      child: listUsers(),
    );
  }
}
