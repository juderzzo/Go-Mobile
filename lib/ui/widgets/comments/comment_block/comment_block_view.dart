import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_comment_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/list_builders/list_comments.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:go/utils/time_calc.dart';
import 'package:stacked/stacked.dart';

import 'comment_block_view_model.dart';

class CommentBlockView extends StatelessWidget {
  final Function(GoForumPostComment) replyToComment;
  final Function(GoForumPostComment) deleteComment;

  final GoForumPostComment comment;
  CommentBlockView({required this.comment, required this.replyToComment, required this.deleteComment});

  List<TextSpan> convertToRichText(String text, CommentBlockViewModel model) {
    List<String> words = text.split(" ");
    List<TextSpan> richText = [
      TextSpan(
        text: '${comment.username} ',
        style: TextStyle(color: appFontColor(), fontSize: 14.0, fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()..onTap = () => model.customNavigationService.navigateToUserView(comment.senderUID!),
      ),
    ];
    words.forEach((word) {
      TextSpan textSpan;
      if (word.startsWith("@")) {
        textSpan = TextSpan(
          text: "$word ",
          style: TextStyle(color: appTextButtonColor(), fontSize: 14.0, fontWeight: FontWeight.w400),
          recognizer: TapGestureRecognizer()..onTap = () => model.navigateToMentionedUser(word.replaceAll("@", "")),
        );
      } else if (word.startsWith("#")) {
        textSpan = TextSpan(
          text: "$word ",
          style: TextStyle(color: appTextButtonColor(), fontSize: 14.0, fontWeight: FontWeight.w400),
        );
      } else {
        textSpan = TextSpan(
          text: "$word ",
          style: TextStyle(color: appFontColor(), fontSize: 14.0, fontWeight: FontWeight.w400),
        );
      }
      richText.add(textSpan);
    });
    return richText;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentBlockViewModel>.reactive(
      onModelReady: (model) => model.initialize(comment.senderUID),
      viewModelBuilder: () => CommentBlockViewModel(),
      builder: (context, model, child) => model.isBusy || model.errorLoadingData
          ? Container()
          : Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: comment.isReply! ? EdgeInsets.only(top: 0.0) : EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => model.customNavigationService.navigateToUserView(comment.senderUID!), //viewUser,
                      child: Row(
                        children: <Widget>[
                          UserProfilePic(
                            userPicUrl: model.authorProfilePicURL,
                            size: comment.isReply! ? 20 : 35,
                            isBusy: false,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: comment.isReply! ? screenWidth(context) - 110 : screenWidth(context) - 80,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14.0, color: appFontColor()),
                              children: convertToRichText(comment.message!, model),
                            ),
                          ),
                        ),
                        comment.image == null
                            ? SizedBox(height: 2)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 100),
                                      child: Image.network(
                                        comment.image,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              TimeCalc().getPastTimeFromMilliseconds(comment.timePostedInMilliseconds!),
                              style: TextStyle(color: appFontColorAlt(), fontSize: 12.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 8.0),
                            comment.isReply!
                                ? Container()
                                : GestureDetector(
                                    onTap: () => replyToComment(comment), //replyAction,
                                    child: Text(
                                      "Reply",
                                      style: TextStyle(color: appFontColorAlt(), fontSize: 12.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            horizontalSpaceSmall,
                            model.isAuthor
                                ? GestureDetector(
                                    onTap: () => deleteComment(comment),
                                    //() => deleteComment(comment),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red[300], fontSize: 12.0, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 8),
                        comment.replies!.length > 0
                            ? model.showingReplies
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () => model.toggleShowReplies(),
                                      child: Text(
                                        "Hide ${comment.replies!.length} replies",
                                        style: TextStyle(color: appFontColorAlt(), fontSize: 12.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => model.toggleShowReplies(),
                                    child: Text(
                                      "- Show ${comment.replies!.length} replies",
                                      style: TextStyle(color: appFontColorAlt(), fontSize: 12.0, fontWeight: FontWeight.bold),
                                    ),
                                  )
                            : Container(),
                        comment.replies!.length > 0 && model.showingReplies
                            ? ListComments(
                                refreshData: null,
                                deleteComment: (val) => deleteComment(val),
                                results: comment.replies!.reversed.toList(growable: true),
                                showingReplies: model.showingReplies,
                                pageStorageKey: null,
                                scrollController: null,
                                refreshingData: null,
                                replyToComment: (val) {},
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
