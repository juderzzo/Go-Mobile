import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/notifications/notification_bell/notification_bell_view.dart';
import 'package:stacked/stacked.dart';

import 'feed_view_model.dart';

class FeedView extends StatelessWidget {

  final GoUser user;
  final VoidCallback navigateToExplorePage;
  
  FeedView({this.user, this.navigateToExplorePage});
  

    Widget head(FeedViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Feed",
            style: TextStyle(
              color: appFontColor(),
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NotificationBellView(uid: user.id),
                
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget bodyEmpty(FeedViewModel model){
    //print(model.causesFollowingResults);
    return Center(
              child: ZeroStateView(
                imageAssetName: 'coding',
                header: "You're Not Following Any Causes or Changemakers",
                subHeader: "Follow the causes and changemakers that youre interested in",
                mainActionButtonTitle: "Explore Causes",
                mainAction: navigateToExplorePage,
                secondaryActionButtonTitle: 'Refresh Page',
                secondaryAction: () => model.refreshCausesFollowing(),

              ),
            );
  }

  Widget bodyFull(FeedViewMode){

  }

  
  


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FeedViewModel>.reactive(
     onModelReady: (model) => model.initialize(currentUser: user),
      viewModelBuilder: () => FeedViewModel(),
            builder: (context, model, child) => Scaffold(
              body: 
              SafeArea(
              child: Container(
                child: Column(
                    children: [
                      head(model),
                      bodyEmpty(model),
                      Container(),
                  ],
                ),
            ),
          )
        ));
      }
}
      
      
