import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutView extends StatelessWidget {
  final GoCause? cause;
  final YoutubePlayer? youtubePlayer;
  final List? images;
  final String? creatorUsername;
  final String? creatorProfilePicURL;
  final VoidCallback? viewCreator;
  final VoidCallback? followUnfollowCause;
  final bool? isFollowing;

  AboutView(
      {this.cause,
      this.youtubePlayer,
      this.images,
      this.creatorUsername,
      this.creatorProfilePicURL,
      this.viewCreator,
      this.followUnfollowCause,
      this.isFollowing});

  Widget causeFollowers(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: cause!.followerCount.toString(),
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
          Container(
            width: 100,
            child: isFollowing == null || isFollowing == false
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
                    textColor: appFontColorAlt(),
                    backgroundColor: appTextFieldContainerColor(),
                    height: 30.0,
                    width: 100,
                    onPressed: followUnfollowCause,
                  ),
          ),
        ],
      ),
    );
  }

  Widget causeDetails(AboutViewModel model, BuildContext context) {
    String? url = cause!.charityURL;
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
            text: cause!.why,
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
            text: cause!.goal,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          CustomText(
            text: cause!.resources!.length > 1 ? "Resources" : " ",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          CustomText(
            text: cause!.resources,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          CustomText(
            text: url != null && url.isNotEmpty ? "Donate!" : " ",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          url != null && url.isNotEmpty
              ? RichText(
                  text: TextSpan(
                  text: '$url',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => UrlHandler().launchInWebViewOrVC(url),
                ))
              : Container(),
          verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget causeCreator(BuildContext context) {
    return CauseAuthorBio(
        username: creatorUsername,
        profilePicURL: creatorProfilePicURL,
        bio: cause!.who);
  }

  @override
  Widget build(BuildContext context) {
    //print('1111');
    //print(cause!.videoLink != null && cause!.videoLink!.isNotEmpty);
    return ViewModelBuilder<AboutViewModel>.reactive(
      viewModelBuilder: () => AboutViewModel(),
      onModelReady: (model) => model.initialize(cause!),
      builder: (context, model, child) => Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            cause!.videoLink != null && cause!.videoLink!.isNotEmpty
                ? _CauseVideoAndImages(youtubePlayer: youtubePlayer)
                : _CauseImages(imgURLs: model.contentURLs),
            SizedBox(
              height: 10,
            ),
            causeFollowers(context),
            causeDetails(model, context),
            causeCreator(context),
          ],
        ),
      ),
    );
  }
}

class _CauseImages extends HookViewModelWidget<AboutViewModel> {
  final List imgURLs;
  _CauseImages({required this.imgURLs});

  @override
  Widget buildViewModelWidget(BuildContext context, AboutViewModel model) {
    //print("chi");

    //print(imgURLs);
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: screenWidth(context),
              aspectRatio: 1,
              viewportFraction: 1,
              onPageChanged: (index, reason) => model.updateImageIndex(index),
            ),
            items: imgURLs.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  //print(url);
                  return Container(
                    height: screenWidth(context),
                    width: screenWidth(context),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,

                      ///placeholder: kTransparentImage,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          imgURLs.length == 1
              ? Container()
              : _BulletIndicator(
                  current: model.currentImageIndex,
                  total: imgURLs.length,
                ),
        ],
      ),
    );
  }
}

///THIS IS A HACKY WAY OF DOING THIS
///I"M NOT A FAN OF THIS SOLUTION, BUT IN THIS MOMENT IN TIME, I'M A TAD TOO LAZY TO FIGURE A BETTER SOLUTION
///WE'RE ALSO ON A TIME CONSTRAINTS SO... ¯\_(ツ)_/¯
///
class _CauseVideoAndImages extends HookViewModelWidget<AboutViewModel> {
  final YoutubePlayer? youtubePlayer;
  _CauseVideoAndImages({required this.youtubePlayer});

  @override
  Widget buildViewModelWidget(BuildContext context, AboutViewModel model) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: screenWidth(context),
              aspectRatio: 1,
              viewportFraction: 1,
              onPageChanged: (index, reason) => model.updateImageIndex(index),
            ),
            items: model.contentURLs.map((url) {
              //print(url);
              return Builder(
                builder: (BuildContext context) {
                  if (url.contains('you')) {
                    return youtubePlayer == null ? Container() : youtubePlayer!;
                  }

                  return Container(
                    height: screenWidth(context),
                    width: screenWidth(context),
                    child: FadeInImage.memoryNetwork(
                      image: url,
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          model.contentURLs.length == 1
              ? Container()
              : _BulletIndicator(
                  current: model.currentImageIndex,
                  total: model.contentURLs.length,
                ),
        ],
      ),
    );
  }
}

class _BulletIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _BulletIndicator({
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final items = new List<int>.generate(total, (i) => i + 1);

    List<T> mapBullets<T>(List list, Function handler) {
      List<T> result = [];

      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }

      return result;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: mapBullets<Widget>(items, (index, url) {
            return Container(
              width: current == index ? 7.0 : 5.0,
              height: current == index ? 7.0 : 5.0,
              margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 3.5,
                  right: index + 1 == total ? 0 : 3.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index ? appFontColor() : appFontColorAlt(),
              ),
            );
          }),
        ));
  }
}

class _CauseFollowers extends HookViewModelWidget<AboutViewModel> {
  final GoCause cause;
  final bool isFollowing;
  _CauseFollowers({required this.cause, required this.isFollowing});

  @override
  Widget buildViewModelWidget(BuildContext context, AboutViewModel model) {
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
          isFollowing == false
              ? CustomButton(
                  isBusy: false,
                  text: "Follow",
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: model.followUnfollowCause(cause: cause),
                )
              : CustomButton(
                  isBusy: false,
                  text: "Following",
                  elevation: 0.0,
                  textColor: appFontColor(),
                  backgroundColor: appButtonColorAlt(),
                  height: 30.0,
                  width: 100,
                  onPressed: model.followUnfollowCause(cause: cause),
                ),
        ],
      ),
    );
  }
}
