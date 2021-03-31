import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:go/ui/widgets/notifications/notification_bell/notification_bell_view.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  final GoUser user;
  final VoidCallback navigateToExplorePage;
  HomeView({this.user, this.navigateToExplorePage});

  Widget head(HomeViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Home",
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
                IconButton(
                  onPressed: () => model.navigateToCreateCauseView(),
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    color: appIconColor(),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listCauses(HomeViewModel model) {
    //print(!model.isReloading);
    return Expanded(
      child: model.causesFollowingResults.isEmpty && !model.isReloading
          ? Center(
              child: ZeroStateView(
                imageAssetName: 'coding',
                header: "You're Not Following Any Causes",
                subHeader: "Find Causes You're Interested In!",
                mainActionButtonTitle: "Explore Causes",
                mainAction: navigateToExplorePage,
                // secondaryActionButtonTitle: 'Refresh Page',
                //secondaryAction: model.refreshCausesFollowing,
              ),
            )
          : ListCauses(
              refreshData: model.refreshCausesFollowing,
              causesResults: model.causesFollowingResults,
              pageStorageKey: PageStorageKey('home-causes'),
              scrollController: model.scrollController,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(currentUser: user),
      viewModelBuilder: () => locator<HomeViewModel>(),
      builder: (context, model, child) => ChangeNotifierProvider.value(
        value: model,
        child: Container(
          height: screenHeight(context),
          color: appBackgroundColor(),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  head(model),
                  listCauses(model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
