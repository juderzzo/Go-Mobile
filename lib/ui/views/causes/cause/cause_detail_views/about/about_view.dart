import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:stacked/stacked.dart';

class AboutView extends StatelessWidget {
  final GoCause cause;
  final List images;
  final String creatorUsername;
  final String creatorProfilePicURL;
  final VoidCallback viewCreator;
  final VoidCallback followUnfollowCause;
  final bool isFollowing;
  AboutView({this.cause, this.images, this.creatorUsername, this.creatorProfilePicURL, this.viewCreator, this.followUnfollowCause, this.isFollowing});

  Widget causeImages(AboutViewModel model) {
    return SizedBox(
      height: 300,
      child: Carousel(
        autoplay: false,
        indicatorBgPadding: 6,
        dotSpacing: 20,
        dotBgColor: appBackgroundColor(),
        dotColor: appFontColorAlt(),
        dotIncreaseSize: 1.01,
        dotIncreasedColor: appFontColor(),
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
              CustomText(
                text: cause.followerCount.toString(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appFontColor(),
              ),
              CustomText(
                text: "Followers",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: appFontColor(),
              ),
            ],
          ),
          isFollowing == null || isFollowing == false
              ? CustomButton(
                  isBusy: false,
                  text: "Follow",
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: followUnfollowCause,
                )
              : CustomButton(
                  isBusy: false,
                  text: "Following",
                  elevation: 0.0,
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: followUnfollowCause,
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
          CustomText(
            text: "Why:",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          CustomText(
            text: cause.why,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          CustomText(
            text: "Goal(s)",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          CustomText(
            text: cause.goal,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          CustomText(
            text: "Resources",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          CustomText(
            text: cause.resources,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget causeCreator(BuildContext context) {
    return CauseAuthorBio(username: creatorUsername, profilePicURL: creatorProfilePicURL, bio: cause.who);
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
