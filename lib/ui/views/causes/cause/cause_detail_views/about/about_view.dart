import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class AboutView extends StatelessWidget {
  final GoCause cause;
  final List images;
  final String creatorUsername;
  final String creatorProfilePicURL;
  final VoidCallback viewCreator;
  final bool isFollowing;
  AboutView({this.cause, this.images, this.creatorUsername, this.creatorProfilePicURL, this.viewCreator, this.isFollowing});

  Widget causeImages(AboutViewModel model) {
    return SizedBox(
      height: 300,
      child: Carousel(
        autoplay: false,
        indicatorBgPadding: 6,
        dotSpacing: 20,
        dotBgColor: Colors.white,
        dotColor: Colors.black12,
        dotIncreaseSize: 1.01,
        dotIncreasedColor: Colors.black45,
        images: images,
      ),
    );
  }

  Widget causeFollowers(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "23.6K",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Followers",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          isFollowing == null || isFollowing == false
              ? CustomButton(
                  isBusy: false,
                  text: "Follow",
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  height: 30.0,
                  width: 100,
                  onPressed: () {},
                )
              : CustomButton(
                  isBusy: false,
                  text: "Following",
                  elevation: 0.0,
                  textColor: Colors.black,
                  backgroundColor: CustomColors.iosOffWhite,
                  height: 30.0,
                  width: 100,
                  onPressed: () {},
                ),
        ],
      ),
    );
  }

  Widget causeDetails(AboutViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Why:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cause.why,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Goal(s):",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cause.goal,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Resources:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cause.resources,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget causeCreator(BuildContext context) {
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: CustomColors.iosOffWhite,
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: UserProfilePic(
              userPicUrl: creatorProfilePicURL,
              size: 40,
              isBusy: false,
            ),
          ),
          SizedBox(width: 8),
          Container(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ABOUT THE CREATOR",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    creatorUsername,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    cause.who,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AboutViewModel>.reactive(
      viewModelBuilder: () => AboutViewModel(),
      builder: (context, model, child) => Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            causeImages(model),
            causeFollowers(context),
            causeDetails(model),
            causeCreator(context),
          ],
        ),
      ),
    );
  }
}
