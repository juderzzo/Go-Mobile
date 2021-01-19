import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/comments/comment_block/comment_block_view.dart';

class ListComments extends StatelessWidget {
  final List results;
  final bool showingReplies;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  final bool refreshingData;
  ListComments(
      {@required this.refreshData,
      @required this.results,
      @required this.showingReplies,
      @required this.pageStorageKey,
      @required this.scrollController,
      @required this.refreshingData});

  Widget listReplies(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (context, index) {
          GoForumPostComment comment;
          bool displayBottomBorder = true;

          ///GET POST OBJECT
          if (results[index] is DocumentSnapshot) {
            comment = GoForumPostComment.fromMap(results[index].data());
          } else {
            comment = results[index];
          }

          ///DISPLAY BOTTOM BORDER
          if (results.last == results[index]) {
            displayBottomBorder = false;
          }
          return CommentBlockView(
            comment: comment,
          );
        },
      ),
    );
  }

  Widget listResults() {
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
        itemCount: results.length,
        itemBuilder: (context, index) {
          GoForumPostComment comment;
          bool displayBottomBorder = true;

          ///GET POST OBJECT
          if (results[index] is DocumentSnapshot) {
            comment = GoForumPostComment.fromMap(results[index].data());
          } else {
            comment = results[index];
          }

          ///DISPLAY BOTTOM BORDER
          if (results.last == results[index]) {
            displayBottomBorder = false;
          }
          return CommentBlockView(
            comment: comment,
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
      child: showingReplies ? listReplies(context) : listResults(),
    );
  }
}