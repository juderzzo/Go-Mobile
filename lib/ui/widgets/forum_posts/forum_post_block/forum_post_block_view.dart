import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:go/utils/time_calc.dart';
import 'package:stacked/stacked.dart';

import 'forum_post_block_view_model.dart';

class ForumPostBlockView extends StatelessWidget {
  final VoidCallback refreshAction;
  final GoForumPost post;
  final bool displayBottomBorder;

  ForumPostBlockView({this.refreshAction, this.post, this.displayBottomBorder});

  Widget postHead(ForumPostBlockViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => model.navigateToUserView(post.authorID),
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
                CustomFittedText(
                  text: model.authorUsername,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                  textAlign: TextAlign.left,
                  height: 20,
                  width: 135,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => model.showOptions(refreshAction: refreshAction, post: post),
            icon: Icon(
              FontAwesomeIcons.ellipsisH,
              size: 16,
              color: appIconColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget postBody(ForumPostBlockViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(
              text: post.body,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: appFontColor(),
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
                    CustomText(
                      text: post.commentCount.toString(),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: appFontColor(),
                    ),
                  ],
                ),
                CustomText(
                  text: TimeCalc().getPastTimeFromMilliseconds(post.dateCreatedInMilliseconds),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: appFontColorAlt(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostBlockViewModel>.reactive(
      onModelReady: (model) => model.initialize(post.authorID),
      viewModelBuilder: () => ForumPostBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.navigateToPostView(post.id),
        child: model.isBusy
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    postHead(model),
                    postBody(model),
                    verticalSpaceSmall,
                    displayBottomBorder
                        ? Divider(
                            thickness: 8.0,
                            color: appPostBorderColor(),
                          )
                        : Container(),
                  ],
                ),
              ),
      ),
    );
  }
}
