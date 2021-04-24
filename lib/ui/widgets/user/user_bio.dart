import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';

class UserBio extends StatelessWidget {
  final String? username;
  final String? profilePicURL;
  final String? bio;
  UserBio({required this.username, required this.profilePicURL, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: appTextFieldContainerColor(),
        border: Border.all(width: 1.0, color: appBorderColor()),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ABOUT ME",
            style: TextStyle(
              fontSize: 12,
              color: appFontColorAlt(),
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 6),
          Text(
            bio!,
            style: TextStyle(
              fontSize: 14,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class CauseAuthorBio extends StatelessWidget {
  final String? username;
  final String? profilePicURL;
  final String? bio;
  CauseAuthorBio({required this.username, required this.profilePicURL, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: appTextFieldContainerColor(),
        border: Border.all(width: 1.0, color: appBorderColorAlt()),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: UserProfilePic(
              userPicUrl: profilePicURL,
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
                      color: appFontColorAlt(),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    username!,
                    style: TextStyle(
                      fontSize: 14,
                      color: appFontColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    bio!,
                    style: TextStyle(
                      fontSize: 14,
                      color: appFontColor(),
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
}
