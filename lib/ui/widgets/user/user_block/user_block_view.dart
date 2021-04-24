import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/user/user_block/user_block_view_model.dart';
import 'package:stacked/stacked.dart';

import '../user_profile_pic.dart';

class UserBlockView extends StatelessWidget {
  final GoUser? user;
  final bool? displayBottomBorder;

  UserBlockView({this.user, this.displayBottomBorder});

  Widget isFollowingUser() {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.userAlt,
            size: 10,
            color: appIconColorAlt(),
          ),
          horizontalSpaceTiny,
          
        ],
      ),
    );
  }

  Widget body(UserBlockViewModel model) {
    return GestureDetector(
      onTap: () => model.navigateToUserView(user!.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: displayBottomBorder! ? appBorderColor() : Colors.transparent, width: 0.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            UserProfilePic(userPicUrl: user!.profilePicURL, size: 35, isBusy: false),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                true ? isFollowingUser() : Container(),
                CustomText(
                  text: user!.username!.length < 20 ? "@${user!.username}" : "@${user!.username!.substring(0,20)}...",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appFontColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserBlockViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initialize(user!.followers!),
      viewModelBuilder: () => UserBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.navigateToUserView(user!.id),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              body(model),
            ],
          ),
        ),
      ),
    );
  }
}
