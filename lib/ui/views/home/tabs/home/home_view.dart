import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/causes/cause_block/cause_block_view.dart';
import 'package:go/ui/views/home/tabs/home/home_view_model.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  Widget head(HomeViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Home",
            style: TextStyle(
              color: Colors.black,
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
                  icon: Icon(FontAwesomeIcons.slidersH, color: Colors.black, size: 20),
                ),
                IconButton(
                  onPressed: () => model.navigateToCreateCauseView(),
                  icon: Icon(FontAwesomeIcons.plus, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listCauses(HomeViewModel model) {
    return ListView.builder(
      controller: null,
      physics: AlwaysScrollableScrollPhysics(),
      key: UniqueKey(),
      shrinkWrap: true,
      padding: EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
      ),
      itemCount: model.causes.length,
      itemBuilder: (context, index) {
        return CauseBlockView(
          currentUID: model.currentUID,
          cause: model.causes[index],
          viewCause: null,
          viewCreator: null,
          showOptions: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
