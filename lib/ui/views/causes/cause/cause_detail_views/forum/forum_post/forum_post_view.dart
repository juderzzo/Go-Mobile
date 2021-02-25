import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view_model.dart';
import 'package:go/ui/widgets/comments/comment_text_field_view.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_comments.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:go/utils/time_calc.dart';
import 'package:mailer/mailer.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ForumPostView extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  ScrollController controller = new ScrollController();

  Widget postBody(ForumPostViewModel model, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          verticalSpaceSmall,
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => model.navigateToUserView(model.author.id),
                  child: Row(
                    children: <Widget>[
                      UserProfilePic(
                        isBusy: false,
                        userPicUrl: model.author.profilePicURL,
                        size: 35,
                      ),
                      horizontalSpaceSmall,
                      Text(
                        "@${model.author.username}",
                        style: TextStyle(
                            color: appFontColor(),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomText(
              text: model.post.body,
              textAlign: TextAlign.left,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          model.post.imageID != null && model.post.imageID.length > 5
              ? Container(
                  //height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    model.post.imageID,
                    //height: 200,

                    //fit: BoxFit.fitWidth,
                    //width: MediaQuery.of(context).size.width
                  ))
              : Container(),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    model.likedPost
                        ? IconButton(
                            onPressed: () {
                              model.likeUnlikePost(model.post.id);

                              model.notifyListeners();
                            },
                            icon: Icon(
                              Icons.favorite,
                              size: 22,
                              color: Colors.redAccent[200],
                            ))
                        : IconButton(
                            onPressed: () {
                              model.likeUnlikePost(model.post.id);
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              size: 22,
                              color: appFontColor(),
                            ),
                          ),
                    horizontalSpaceSmall,
                  ],
                ),
                Text(
                  TimeCalc().getPastTimeFromMilliseconds(
                      model.post.dateCreatedInMilliseconds),
                  style: TextStyle(
                    color: appFontColorAlt(),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Divider(
            thickness: 8.0,
            color: appPostBorderColor(),
          ),
        ],
      ),
    );
  }

  postComments(ForumPostViewModel model) {
    return ListComments(
      refreshData: () async {},
      scrollController: controller,
      showingReplies: false,
      pageStorageKey: PageStorageKey('post-comments'),
      refreshingData: false,
      results: model.commentResults,
      replyToComment: (val) => model.toggleReply(focusNode, val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostViewModel>.reactive(
      onModelReady: (model) => model.initialize(context),
      viewModelBuilder: () => ForumPostViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicActionAppBar(
          title: "Forum Post",
          showBackButton: true,
          actionWidget: IconButton(
            onPressed: () {
              model.showOptions();
            },
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => model.clearState(context),
          child: Container(
            height: screenHeight(context),
            color: appBackgroundColor(),
            child: model.isBusy
                ? Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Stack(
                    children: [
                      RefreshIndicator(
                        backgroundColor: appBackgroundColor(),
                        onRefresh: () async {},
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            postBody(model, context),
                            postComments(model),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                      !model.commentSending
                          ? Container(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Spacer(
                                    flex: 20,
                                  ),
                                  CommentTextFieldView(
                                    onSubmitted: model.isReplying
                                        ? (val) {
                                            if (val == null &&
                                                model.img != null) {
                                              val = "";
                                            }
                                            model.replyToComment(
                                                context: context,
                                                commentVal: val,
                                                image: model.img);
                                            model.setBusy(true);

                                            model.img = null;
                                            model.setBusy(false);
                                          }
                                        : (val) {
                                          if (val == null &&
                                                model.img != null) {
                                              val = "";
                                            }
                                            model.submitComment(
                                              context: context,
                                              commentVal: val,
                                              image: model.img,
                                              //image:
                                            );
                                            model.setBusy(true);

                                            model.img = null;
                                            model.setBusy(false);

                                            //model.setBusy(false);
                                          },
                                    selectImage: model.selectImage,
                                    focusNode: focusNode,
                                    commentTextController:
                                        model.commentTextController,
                                    isReplying: model.isReplying,
                                    replyReceiverUsername: model.isReplying
                                        ? model.commentToReplyTo.username
                                        : null,
                                  ),
                                  model.img != null
                                      ? Container(
                                          color: isDarkMode()
                                              ? Color.fromRGBO(22, 22, 22, 1)
                                              : appBackgroundColor(),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                1 /
                                                                4 -
                                                            23,
                                                  ),
                                                  SizedBox(
                                                    height: 22,
                                                    width: 22,
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color: CustomColors
                                                              .goGreen,
                                                          size: 15,
                                                        ),
                                                        onPressed: () {
                                                          model.img = null;
                                                          model
                                                              .notifyListeners();
                                                        }),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            4,
                                                  ),
                                                  ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight: 100,
                                                        maxWidth: 600,
                                                      ),
                                                      child: Image.file(
                                                          model.imgFile)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        1 /
                                        20,
                                    color: model.isDarkMode()
                                        ? Color.fromRGBO(22, 22, 22, 1)
                                        : appBackgroundColor(),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Spacer(flex: 20),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  child: LinearProgressIndicator(),
                                ),
                                Spacer(),
                              ],
                            ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
