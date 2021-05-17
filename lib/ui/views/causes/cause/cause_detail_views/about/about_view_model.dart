import 'package:flutter/cupertino.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/dynamic_links/dynamic_link_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/user_data_service.dart';
import 'package:go/services/reactive/user/reactive_user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutViewModel extends BaseViewModel {
  AuthService? _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  CauseDataService _causeDataService = locator<CauseDataService>();
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  ReactiveUserService _reactiveUserService = locator<ReactiveUserService>();

  GoUser get user => _reactiveUserService.user;

  String? creatorUsername;
  String? creatorProfilePicURL;
  bool isCreator = false;
  bool isLoading = true;
  List images = [];
  List contentURLs = [];
  String? videoLink;
  int orgLength = 0;
  int currentImageIndex = 0;
  String? videoID;
  late YoutubePlayerController youtubePlayerController;
  late YoutubePlayer youtubePlayer;

  initialize(GoCause cause) async {
    GoUser creator = await _userDataService.getGoUserByID(cause.creatorID);

    if (user.id == cause.creatorID) {
      isCreator = true;
    }
    creatorUsername = "@" + creator.username!;
    creatorProfilePicURL = creator.profilePicURL;

    if (cause.videoLink != null && cause.videoLink!.isNotEmpty) {
      contentURLs.add(cause.videoLink!);
      orgLength++;
      cause.imageURLs!.forEach((url) {
        images.add(
          NetworkImage(url),
        );
        contentURLs.add(
          url,
        );
        orgLength++;
      });

      //configure youtube player
      videoID = YoutubePlayer.convertUrlToId(cause.videoLink!);
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: YoutubePlayerFlags(
          isLive: true,
          disableDragSeek: true,
          autoPlay: true,
          hideControls: false,
          mute: true,
          controlsVisibleAtStart: true,
        ),
      );
      youtubePlayer = YoutubePlayer(
        controller: youtubePlayerController,
        liveUIColor: CustomColors.goGreen,
        actionsPadding: EdgeInsets.only(bottom: 10.0),
      );
      notifyListeners();
    } else {
      cause.imageURLs!.forEach((url) {
        images.add(
          NetworkImage(url),
        );
        contentURLs.add(
          url,
        );
        orgLength++;
      });
    }

    isLoading = false;
    notifyListeners();
  }

  updateImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }

  followUnfollowCause({required GoCause cause}) {
    _causeDataService.followUnfollowCause(cause.id!, user.id!);
  }

  ///NAVIGATION
// replaceWithPage() {
//   _navigationService.replaceWith(PageRouteName);
// }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }
}
