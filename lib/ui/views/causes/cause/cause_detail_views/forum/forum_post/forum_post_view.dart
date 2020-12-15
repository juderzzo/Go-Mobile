import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view_model.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class ForumPostView extends StatelessWidget {
  final String postAuthorProfilePicURL;
  final String postAuthorProfilePicName;

  ForumPostView({this.postAuthorProfilePicName, this.postAuthorProfilePicURL});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostViewModel>.reactive(
      viewModelBuilder: () => ForumPostViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: null,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 4.0),
                //widget.postOptions == null ? EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0) : EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 4.0),
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
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            postAuthorProfilePicName,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.comment,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "3 hours ago", //TimeCalc().getPastTimeFromMilliseconds(widget.post.postDateTimeInMilliseconds),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Divider(
                thickness: 8.0,
                color: CustomColors.iosOffWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
