import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause_block/cause_block_view_model.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class CauseBlockView extends StatelessWidget {
  final String currentUID;
  final GoCause cause;
  final VoidCallback viewCause;
  final VoidCallback viewCreator;
  final VoidCallback showOptions;

  CauseBlockView({this.currentUID, this.cause, this.viewCause, this.viewCreator, this.showOptions});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseBlockViewModel>.reactive(
      viewModelBuilder: () => CauseBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: viewCause,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: viewCreator,
                      child: Row(
                        children: <Widget>[
                          model.isLoading
                              ? Shimmer.fromColors(
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  baseColor: CustomColors.iosOffWhite,
                                  highlightColor: Colors.white,
                                )
                              : UserProfilePic(userPicUrl: model.createProfilePicURL, size: 35),
                          SizedBox(
                            width: 10.0,
                          ),
                          model.isLoading
                              ? Container()
                              : Text(
                                  "", // model.creatorUsername,
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: showOptions,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: screenWidthFraction(context, dividedBy: 2),
                  width: screenWidth(context),
                  child: Carousel(
                    images: model.images,
                  )),
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
                          "", //cause.forumPostCount.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      "Organized By:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "", // model.creatorUsername,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Goal(s):",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "", // cause.goal,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
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
