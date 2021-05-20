import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/comments/comment_text_field_view.dart';
import 'package:go/ui/widgets/list_builders/list_comments.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:go/utils/linkify_text.dart';
import 'package:go/utils/time_calc.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:transparent_image/transparent_image.dart';

import 'forum_post_view_model.dart';

class ForumPostView extends StatelessWidget {
  final String? id;
  ForumPostView(@PathParam() this.id);
  //final FocusNode focusNode = FocusNode();

  Widget postHead(ForumPostViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => model.navigateToUserView(model.author!.id),
            child: Row(
              children: <Widget>[
                UserProfilePic(
                  isBusy: false,
                  userPicUrl: model.author!.profilePicURL,
                  size: 35,
                ),
                horizontalSpaceSmall,
                Text(
                  "@${model.author!.username}",
                  style: TextStyle(
                    color: appFontColor(),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postImg(BuildContext context, String url) {
    // return FadeInImage.memoryNetwork(
    //   image: url,
    //   fit: BoxFit.cover,
    //   placeholder: kTransparentImage,
    // );
    return Image.network(
      url,
    );
  }

  Widget postMessage(ForumPostViewModel model) {
    List<TextSpan> linkifiedText = [];

    if (model.post!.imageID == null) {
      linkifiedText = linkify(text: model.post!.body!.trim(), fontSize: 18);
    } else {
      TextSpan usernameTextSpan = TextSpan(
        text: '@${model.author!.username} ',
        style: TextStyle(
          color: appFontColor(),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      linkifiedText.add(usernameTextSpan);
      linkifiedText
          .addAll(linkify(text: model.post!.body!.trim(), fontSize: 14));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          children: linkifiedText,
        ),
      ),
    );
  }

  Widget postCommentCountAndTime(ForumPostViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.comment,
                size: 16,
                color: appFontColor(),
              ),
              horizontalSpaceSmall,
              Text(
                model.post!.commentCount.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: appFontColor(),
                ),
              ),
            ],
          ),
          Text(
            TimeCalc().getPastTimeFromMilliseconds(
                model.post!.dateCreatedInMilliseconds!),
            style: TextStyle(
              color: appFontColorAlt(),
            ),
          ),
        ],
      ),
    );
  }

  Widget postBody(BuildContext context, ForumPostViewModel model) {
    return model.post!.imageID == null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceSmall,
                postHead(model),
                verticalSpaceSmall,
                postMessage(model),
                verticalSpaceSmall,
                postCommentCountAndTime(model),
                verticalSpaceSmall,
                Divider(
                  thickness: 8.0,
                  color: appBorderColorAlt(),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceSmall,
                postHead(model),
                verticalSpaceSmall,
                postImg(context, model.post!.imageID!),
                verticalSpaceSmall,
                postCommentCountAndTime(model),
                verticalSpaceSmall,
                postMessage(model),
                verticalSpaceSmall,
                Divider(
                  thickness: 8.0,
                  color: appBorderColorAlt(),
                ),
              ],
            ),
          );
  }

  postComments(BuildContext context, ForumPostViewModel model) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth(context),
      ),
      child: ListComments(
        refreshData: () async {},
        scrollController: null,
        showingReplies: false,
        pageStorageKey: model.commentStorageKey,
        refreshingData: false,
        results: model.commentResults,
        replyToComment: (val) => model.toggleReply(model.focusNode, val),
        deleteComment: (val) =>
            model.showDeleteCommentConfirmation(context: context, comment: val),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostViewModel>.reactive(
      onModelReady: (model) => model.initialize(id!),
      viewModelBuilder: () => ForumPostViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicActionAppBar(
          title: "Post",
          showBackButton: true,
          actionWidget: IconButton(
            onPressed:
                model.post == null ? null : () => model.showContentOptions(),
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => model.unFocusKeyboard(context),
          child: Container(
            height: screenHeight(context),
            color: appBackgroundColor(),
            child: model.isBusy
                ? Container()
                : model.post == null
                    ? Container()
                    : Stack(
                        children: [
                          RefreshIndicator(
                            backgroundColor: appBackgroundColor(),
                            onRefresh: () async {},
                            child: ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: model.postScrollController,
                              shrinkWrap: true,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth(context),
                                    ),
                                    child: Column(
                                      children: [
                                        postBody(context, model),
                                        postComments(context, model),
                                        SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CommentTextFieldView(
                              onSubmitted: model.isReplying
                                  ? (val) => model.replyToComment(
                                        context: context,
                                        commentData: val,
                                      )
                                  : (val) => model.submitComment(
                                      context: context, commentData: val),
                              focusNode: model.focusNode,
                              commentTextController:
                                  model.commentTextController,
                              isReplying: model.isReplying,
                              replyReceiverUsername: model.isReplying
                                  ? model.commentToReplyTo!.username
                                  : null,
                              contentID: '',
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
