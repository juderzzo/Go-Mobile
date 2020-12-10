import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/page_models/home_page_models/screen_models/profile_screen_model.dart';
import 'package:go/ui/widgets/user/follow_stats_row.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class ProfileScreen extends StatelessWidget {
  Widget head(ProfileScreenModel model) {
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

  Widget userDetails() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 16),
          UserProfilePic(
            userPicUrl: "",
            size: 60,
          ),
          SizedBox(height: 8),
          Text(
            "@username",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8),
          FollowStatsRow(
            followersLength: 200,
            followingLength: 1039,
            viewFollowersAction: null,
            viewFollowingAction: null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileScreenModel>.withConsumer(
      viewModelBuilder: () => ProfileScreenModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                head(model),
                userDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
