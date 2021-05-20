import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'cause_block_view_model.dart';

class CauseBlockView extends StatelessWidget {
  final GoCause cause;
  final bool? displayBottomBorder;

  CauseBlockView({required this.cause, this.displayBottomBorder});

  Widget causeImages(CauseBlockViewModel model, context) {
    List<dynamic> images = model.images;
    //print(cause.videoLink);
    //print(images.length);
    //print(model.orgLength);
    //print(model.videoLink);
    YoutubePlayerController _controller;
    if ((cause.videoLink != null) && cause.videoLink!.length > 5 && images.length == model.orgLength) {
      //print(cause.videoLink);
      String? videoID = YoutubePlayer.convertUrlToId(cause.videoLink!);
      //print(videoID);
      if (videoID != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoID,
          flags: YoutubePlayerFlags(
            isLive: true,
            disableDragSeek: true,
            hideControls: true,
            mute: true,
          ),
        );

        YoutubePlayer video = YoutubePlayer(
          aspectRatio: 16 / 11,
          controller: _controller,
          liveUIColor: CustomColors.goGreen,
          actionsPadding: EdgeInsets.only(bottom: 10.0),
        );
        images.add(ListView.separated(
          itemBuilder: (context, index) {
            return video;
          },
          itemCount: 1,
          separatorBuilder: (context, _) => const SizedBox(height: 10.0),
        ));
      }
    }

    return Container(); //model.isLoading
    // ? Container()
    // : SizedBox(
    //     width: MediaQuery.of(context).size.width * 23 / 24,
    //     height: 250,
    //     child: Carousel(
    //       autoplay: false,
    //       indicatorBgPadding: 6,
    //       dotSpacing: 20,
    //       dotBgColor: appBackgroundColor(),
    //       dotColor: appFontColorAlt(),
    //       dotIncreaseSize: 1.01,
    //       dotIncreasedColor: appFontColor(),
    //       //showIndicator: model.images.length > 1 ? true : false,
    //       images: images,
    //     ),
    //   );
  }

  Widget causeDetails(CauseBlockViewModel model, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 23 / 24,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: appBackgroundColor(),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          model.images.length > 1 ? Container() : verticalSpaceMedium,
          Text(
            "Why:",
            style: TextStyle(
              fontSize: 16,
              color: appFontColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (cause.why!.length < 95) ? cause.why! : cause.why!.substring(0, 85) + "... See More",
            style: TextStyle(
              fontSize: 14,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Goal(s):",
            style: TextStyle(
              fontSize: 16,
              color: appFontColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (cause!.goal!.length < 95) ? cause!.goal! : cause!.goal!.substring(0, 85) + "... See More",
            style: TextStyle(
              fontSize: 14,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget causeOrganizer(CauseBlockViewModel model, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 23 / 24,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Organized by ',
              style: TextStyle(color: appFontColor()),
            ),
            TextSpan(
              text: model.creatorUsername,
              style: TextStyle(color: appTextButtonColor()),
              recognizer: TapGestureRecognizer()..onTap = () => model.customNavigationService.navigateToUserView(cause.creatorID!),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseBlockViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initialize(cause),
      viewModelBuilder: () => CauseBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.navigateToCauseView(cause.id),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: appBackgroundColor(),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Head(causeName: cause.name!, showOptions: () => model.customBottomSheetService.showContentOptions(content: cause)),
              cause.videoLink != null ? _CauseVideoAndImages() : _CauseImages(imgURLs: cause.imageURLs!),
              causeDetails(model, context),
              causeOrganizer(model, context),
              SizedBox(height: 16.0),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Head extends HookViewModelWidget<CauseBlockViewModel> {
  final String causeName;
  final VoidCallback showOptions;
  _Head({required this.causeName, required this.showOptions});

  @override
  Widget buildViewModelWidget(BuildContext context, CauseBlockViewModel model) {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 3 / 4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Text(
                  causeName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: appIconColor(),
            ),
            onPressed: showOptions,
          ),
        ],
      ),
    );
  }
}

class _CauseImages extends HookViewModelWidget<CauseBlockViewModel> {
  final List imgURLs;
  _CauseImages({required this.imgURLs});

  @override
  Widget buildViewModelWidget(BuildContext context, CauseBlockViewModel model) {
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
class _CauseVideoAndImages extends HookViewModelWidget<CauseBlockViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CauseBlockViewModel model) {
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
              return Builder(
                builder: (BuildContext context) {
                  if (url.contains('you')) {
                    return model.youtubePlayer;
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
              margin: EdgeInsets.only(left: index == 0 ? 0 : 3.5, right: index + 1 == total ? 0 : 3.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index ? appFontColor() : appFontColorAlt(),
              ),
            );
          }),
        ));
  }
}
