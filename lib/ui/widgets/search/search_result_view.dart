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
  final bool displayBottomBorder;

  UserSearchResultView({@required this.onTap, @required this.searchResult, @required this.isFollowing, @required this.displayBottomBorder});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: displayBottomBorder ? appBorderColor() : Colors.transparent, width: 0.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            UserProfilePic(userPicUrl: searchResult.additionalData, size: 35, isBusy: false),
            SizedBox(
              width: 10.0,
            ),
            
                
                CustomText(
                  text: "@${searchResult.name}",
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: appFontColor(),
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
  final bool displayBottomBorder;

  CauseSearchResultView({@required this.onTap, @required this.searchResult, @required this.isFollowing, @required this.displayBottomBorder});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: displayBottomBorder ? appBorderColor() : Colors.transparent, width: 0.5),
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
  final VoidCallback onSearchTermSelected;
  final String searchTerm;
  final bool displayBottomBorder;
  final bool displayIcon;

  RecentSearchTermView({@required this.onSearchTermSelected, @required this.searchTerm, @required this.displayBottomBorder, @required this.displayIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTermSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: displayBottomBorder ? appBorderColor() : Colors.transparent, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: searchTerm,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
            displayIcon ? Icon(FontAwesomeIcons.clock, color: appIconColorAlt(), size: 12) : Container(),
          ],
        ),
      ),
    );
  }
}

class ViewAllResultsSearchTermView extends StatelessWidget {
  final VoidCallback onSearchTermSelected;
  final String searchTerm;

  ViewAllResultsSearchTermView({@required this.onSearchTermSelected, @required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTermSelected,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: searchTerm,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appTextButtonColor(),
            ),
            //Icon(FontAwesomeIcons.clock, color: appIconColorAlt(), size: 12)
          ],
        ),
      ),
    );
  }
}
