import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:go/ui/widgets/list_builders/list_causes.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  final GoUser user;
  HomeView({this.user});

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
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    FontAwesomeIcons.slidersH,
                    color: appIconColor(),
                    size: 20,
                  ),
                ),
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
    return Expanded(
      child: ListCauses(
        refreshData: model.refreshCausesFollowing,
        causesResults: model.causesFollowingResults,
        pageStorageKey: PageStorageKey('home-causes'),
        scrollController: model.scrollController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(currentUser: user),
      viewModelBuilder: () => locator<HomeViewModel>(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
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
    );
  }
}
