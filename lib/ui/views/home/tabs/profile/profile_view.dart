import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/home/tabs/profile/profile_view_model.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  Widget head(ProfileViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          IconButton(
            onPressed: () => model.navigateToSettingsPage(),
            icon: Icon(FontAwesomeIcons.cog, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget userDetails(ProfileViewModel model) {
    return model.isBusy
        ? Container(
            child: Column(
              children: [
                SizedBox(height: 16),
                UserProfilePic(
                  userPicUrl: "",
                  size: 60,
                  isBusy: true,
                ),
              ],
            ),
          )
        : Container(
            child: Column(
              children: [
                SizedBox(height: 16),
                UserProfilePic(
                  userPicUrl: model.currentUser.profilePicURL,
                  size: 60,
                  isBusy: false,
                ),
                SizedBox(height: 8),
                Text(
                  "@${model.currentUser.username}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8),
                FollowStatsRow(
                  followersLength: model.currentUser.followers.length,
                  followingLength: model.currentUser.following.length,
                  viewFollowersAction: null,
                  viewFollowingAction: null,
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                head(model),
                userDetails(model),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
