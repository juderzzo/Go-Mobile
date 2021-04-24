import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/about/about_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_bio.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutView extends StatelessWidget {
  final GoCause? cause;
  final List? images;
  final String? creatorUsername;
  final String? creatorProfilePicURL;
  final VoidCallback? viewCreator;
  final VoidCallback? followUnfollowCause;
  final bool? isFollowing;
  int? orgLength;
  YoutubePlayerController? _controller;
  String? videoID;
  bool initialized = false;
  YoutubePlayerBuilder? video;

  AboutView({this.cause, this.images, this.creatorUsername, this.creatorProfilePicURL, this.viewCreator, this.followUnfollowCause, this.isFollowing});

  initialize() {
    if (cause!.videoLink != null && cause!.videoLink!.length > 5) {
      videoID = YoutubePlayer.convertUrlToId(cause!.videoLink!);
    }

    if (videoID != null) {
      _controller = new YoutubePlayerController(
        initialVideoId: videoID!,
        flags: YoutubePlayerFlags(
            isLive: true,
            disableDragSeek: true,
            autoPlay: true,
            //hideControls: true,
            loop: true),
      );
    }
    //print(_controller.value);
  }

  Widget causeImages(AboutViewModel model, Orientation orientation) {
    //print(images.length);

    if ((cause!.videoLink != null) && cause!.videoLink!.length > 5 && images!.length == orgLength) {
      //print(cause.videoLink);

      //print(videoID);
      if (videoID != null) {
        YoutubePlayerBuilder video = YoutubePlayerBuilder(
            player: YoutubePlayer(
              aspectRatio: 17 / 9,
              controller: _controller!,
              liveUIColor: CustomColors.goGreen,
              actionsPadding: EdgeInsets.only(bottom: 20.0),
            ),
            builder: (context, player) {
              return Column(
                children: [
                  // some widgets
                  player,
                  //some other widgets
                ],
              );
            });
        images!.insert(
            0,
            ListView.separated(
              itemBuilder: (context, index) {
                return video;
              },
              itemCount: 1,
              separatorBuilder: (context, _) => const SizedBox(height: 0.1),
            ));
      }
    }

    return Container();
    // SizedBox(
    //   height: 210,
    //
    //   child: Carousel(
    //     autoplay: false,
    //     showIndicator: false,
    //     indicatorBgPadding: 6,
    //     dotSpacing: 20,
    //     dotBgColor: appBackgroundColor(),
    //     dotColor: appFontColorAlt(),
    //     dotIncreaseSize: 1.01,
    //     dotIncreasedColor: appFontColor(),
    //     images: images,
    //   ),
    // );
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

  Widget causeDetails(AboutViewModel model, BuildContext context) {
    String url = cause!.charityURL!;
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
            text: cause!.charityURL!.length > 1 ? "Donate!" : " ",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          url.length > 5
              ? RichText(
                  text: TextSpan(
                  text: '$url',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()..onTap = () => UrlHandler().launchInWebViewOrVC(context, "$url"),
                ))
              : Container(),
          verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget causeCreator(BuildContext context) {
    return CauseAuthorBio(username: creatorUsername, profilePicURL: creatorProfilePicURL, bio: cause!.who);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AboutViewModel>.reactive(
      viewModelBuilder: () => AboutViewModel(),
      onModelReady: (f) {
        orgLength = cause!.imageURLs!.length;
        if (!initialized) {
          initialize();
          initialized = true;
          //_controller.addListener(listener);
        }

        if (_controller != null) {
          print(_controller!.value.isPlaying);
          //_controller.play();

        }
      },
      builder: (context, model, child) => OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          if (_controller != null) {
            _controller!.reset();
          }

          return YoutubePlayerBuilder(
              player: YoutubePlayer(
                aspectRatio: 17 / 9,
                controller: _controller!,
                liveUIColor: CustomColors.goGreen,
                actionsPadding: EdgeInsets.only(bottom: 20.0),
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    // some widgets
                    player,
                    //some other widgets
                  ],
                );
              });
        } else {
          if (_controller != null) {
            _controller!.reset();
          }

          return Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                causeImages(model, orientation),
                SizedBox(
                  height: 10,
                ),
                causeFollowers(context),
                causeDetails(model, context),
                causeCreator(context),
              ],
            ),
          );
        }
      }),
    );
  }
}
