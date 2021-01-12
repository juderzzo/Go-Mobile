import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';

class UserSearchResultView extends StatelessWidget {
  final VoidCallback onTap;
  final SearchResult searchResult;
  final bool isFollowing;

  UserSearchResultView({@required this.onTap, @required this.searchResult, @required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: appBorderColor(), width: 1),
            bottom: BorderSide(color: appBorderColor(), width: 1),
          ),
        ),
        child: Row(
          children: <Widget>[
            UserProfilePic(userPicUrl: searchResult.additionalData, size: 20, isBusy: false),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isFollowing
                    ? Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.user,
                            size: 12,
                            color: appIconColorAlt(),
                          ),
                          CustomText(
                            text: "following",
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: appFontColorAlt(),
                          ),
                        ],
                      )
                    : Container(),
                CustomText(
                  text: "@${searchResult.name}",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CauseSearchResultView extends StatelessWidget {
  final VoidCallback onTap;
  final SearchResult searchResult;
  final bool isFollowing;

  CauseSearchResultView({@required this.onTap, @required this.searchResult, @required this.isFollowing});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: appBorderColor(), width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFollowing
                ? CustomText(
                    text: "following",
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: appFontColorAlt(),
                  )
                : Container(),
            CustomText(
              text: "${searchResult.name}",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentSearchTermView extends StatelessWidget {
  final VoidCallback onTap;
  final String searchTerm;

  RecentSearchTermView({@required this.onTap, @required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: appBorderColor(), width: 1),
          ),
        ),
        child: CustomText(
          text: searchTerm,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: appFontColor(),
        ),
      ),
    );
  }
}
