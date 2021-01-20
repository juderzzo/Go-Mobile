import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';

class ListPosts extends StatelessWidget {
  final List postResults;
  final VoidCallback refreshData;
  final ScrollController scrollController;
  final bool refreshingData;
  ListPosts({@required this.refreshData, @required this.postResults, @required this.scrollController, @required this.refreshingData});

  Widget noResults() {
    return ListView(
      shrinkWrap: true,
      children: [
        verticalSpaceMedium,
        CustomText(
          text: "No Posts Found",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          color: appFontColorAlt(),
        ),
      ],
    );
  }

  Widget listPosts() {
    return RefreshIndicator(
      onRefresh: refreshData,
      backgroundColor: appBackgroundColor(),
      child: postResults.isEmpty && !refreshingData
          ? noResults()
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              // key: UniqueKey(),
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: 4.0,
              ),
              itemCount: postResults.length,
              itemBuilder: (context, index) {
                GoForumPost post;
                bool displayBottomBorder = true;

                ///GET POST OBJECT
                if (postResults[index] is DocumentSnapshot) {
                  post = GoForumPost.fromMap(postResults[index].data());
                } else {
                  post = postResults[index];
                }

                ///DISPLAY BOTTOM BORDER
                if (postResults.last == postResults[index]) {
                  displayBottomBorder = false;
                }
                return ForumPostBlockView(
                  refreshAction: refreshData,
                  post: post,
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
      child: listPosts(),
    );
  }
}
