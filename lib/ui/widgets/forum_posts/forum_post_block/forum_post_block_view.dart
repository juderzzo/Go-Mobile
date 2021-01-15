import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

import 'forum_post_block_view_model.dart';

class ForumPostBlockView extends StatelessWidget {
  final String postAuthorProfilePicURL;
  final String postAuthorProfilePicName;

  ForumPostBlockView({this.postAuthorProfilePicName, this.postAuthorProfilePicURL});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostBlockViewModel>.reactive(
      viewModelBuilder: () => ForumPostBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                            userPicUrl: postAuthorProfilePicURL,
                            size: 35,
                          ),
                          horizontalSpaceSmall,
                          Text(
                            postAuthorProfilePicName,
                            style: TextStyle(color: appFontColor(), fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => model.showOptions(),
                      icon: Icon(
                        FontAwesomeIcons.ellipsisH,
                        size: 16,
                        color: appIconColor(),
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
        ),
      ),
    );
  }
}
