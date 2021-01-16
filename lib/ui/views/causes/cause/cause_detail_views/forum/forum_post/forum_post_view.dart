import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view_model.dart';
import 'package:go/ui/widgets/comments/comment_text_field_view.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class ForumPostView extends StatelessWidget {
  final FocusNode focusNode = FocusNode();

  Widget postBody(ForumPostViewModel model) {
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
                  onTap: null,
                  child: Row(
                    children: <Widget>[
                      // isLoading
                      //     ? Shimmer.fromColors(
                      //   child: Container(
                      //     height: 35,
                      //     width: 35,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //     ),
                      //   ),
                      //   baseColor: CustomColors.iosOffWhite,
                      //   highlightColor: Colors.white,
                      // )
                      //     :
                      UserProfilePic(
                        isBusy: false,
                        userPicUrl: model.authorProfilePicURL,
                        size: 35,
                      ),
                      horizontalSpaceSmall,
                      Text(
                        model.authorUsername,
                        style: TextStyle(color: appFontColor(), fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
              style: TextStyle(color: appFontColor(), fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
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
                      "0",
                      style: TextStyle(
                        fontSize: 18,
                        color: appFontColor(),
                      ),
                    ),
                  ],
                ),
                Text(
                  "3 hours ago", //TimeCalc().getPastTimeFromMilliseconds(widget.post.postDateTimeInMilliseconds),
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
            onPressed: () => model.showOptions(),
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ),
        body: Container(
          height: screenHeight(context),
          color: appBackgroundColor(),
          child: model.isBusy
              ? Container()
              : Stack(
                  children: [
                    GestureDetector(
                      onTap: null, //() => dismissKeyboard(),
                      child: RefreshIndicator(
                        backgroundColor: appBackgroundColor(),
                        onRefresh: () async {},
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            postBody(model),
                            //postComments(),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: CommentTextFieldView(
                        focusNode: focusNode,
                        commentTextController: model.commentTextController,
                        isReplying: false,
                        replyReceiverUsername: null,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
