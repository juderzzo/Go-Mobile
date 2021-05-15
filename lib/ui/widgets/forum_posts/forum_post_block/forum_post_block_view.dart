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
  final VoidCallback? refreshAction;
  final GoForumPost? post;
  final bool? displayBottomBorder;

  ForumPostBlockView({this.refreshAction, this.post, this.displayBottomBorder});

  Widget postHead(ForumPostBlockViewModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => model.customNavigationService.navigateToUserView(post!.authorID!),
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
                  width: 200,
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

  Widget postBody(ForumPostBlockViewModel model, BuildContext context) {
    // Image postImage = Image.network(
    //   post.imageID,
    // );
    // imMethods.Image postImage =
    // var resize = imMethods.copyResize(
    //   postImage,
    //   width: 200);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(
              text: post!.body,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: appFontColor(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    post!.imageID != null && post!.imageID!.length > 5
                        ? Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(post!.imageID!, height: 200, fit: BoxFit.fitWidth, width: MediaQuery.of(context).size.width),
                          )
                        : Container(),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        horizontalSpaceMedium,
                        Icon(
                          FontAwesomeIcons.comment,
                          size: 16,
                          color: appFontColor(),
                        ),
                        horizontalSpaceSmall,
                        CustomText(
                          text: post!.commentCount.toString(),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: appFontColor(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 4 / 9,
                        ),
                        model.likedPost
                            ? IconButton(
                                onPressed: () {
                                  model.likeUnlikePost(post!.id);

                                  model.notifyListeners();
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  size: 22,
                                  color: Colors.redAccent[200],
                                ))
                            : IconButton(
                                onPressed: () {
                                  model.likeUnlikePost(post!.id);
                                },
                                icon: Icon(
                                  Icons.favorite_border,
                                  size: 22,
                                  color: appFontColor(),
                                ),
                              ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 / 5,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Spacer(flex: 10),
                          CustomText(
                            text: TimeCalc().getPastTimeFromMilliseconds(post!.dateCreatedInMilliseconds!),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: appFontColorAlt(),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
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
    ///print(post.imageID);
    return ViewModelBuilder<ForumPostBlockViewModel>.reactive(
      onModelReady: (model) => model.initialize(post!.authorID, post!.causeID, post!.id),
      viewModelBuilder: () => ForumPostBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.customNavigationService.navigateToForumPostView(post!.id!),
        child: model.isBusy
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    postHead(model),
                    postBody(model, context),
                    verticalSpaceSmall,
                    displayBottomBorder!
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
