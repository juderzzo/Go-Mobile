import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'cause_block_view_model.dart';

class CauseBlockView extends StatelessWidget {
  final GoCause cause;
  final bool displayBottomBorder;

  CauseBlockView({this.cause, this.displayBottomBorder});

  Widget causeHead(CauseBlockViewModel model, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 23/24,
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            cause.name,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: appIconColor(),
            ),
            onPressed: () => model.showOptions(context, cause.id, cause),
          ),
        ],
      ),
    );
  }

  Widget causeImages(CauseBlockViewModel model, context) {
    return model.isLoading
        ? Container()
        : SizedBox(
            width: MediaQuery.of(context).size.width * 23/24,
            height: 250,
            child: Carousel(
              autoplay: false,
              indicatorBgPadding: 6,
              dotSpacing: 20,
              dotBgColor: appBackgroundColor(),
              dotColor: appFontColorAlt(),
              dotIncreaseSize: 1.01,
              dotIncreasedColor: appFontColor(),
              showIndicator: model.images.length > 1 ? true : false,
              images: model.images,
            ),
          );
  }

  Widget causeDetails(CauseBlockViewModel model, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 23/24,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
                color: appBackgroundColor(),
                borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          model.images.length > 1 ? Container() : verticalSpaceMedium,
          Text(
            "Why:",
            style: TextStyle(
              fontSize: 16,
              color: appFontColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (cause.why.length < 95) ? cause.why : cause.why.substring(0,85) + "... See More",
            style: TextStyle(
              fontSize: 14,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Goal(s):",
            style: TextStyle(
              fontSize: 16,
              color: appFontColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (cause.goal.length < 95) ? cause.goal : cause.goal.substring(0,85) + "... See More",
            style: TextStyle(
              fontSize: 14,
              color: appFontColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget causeOrganizer(CauseBlockViewModel model, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 23/24,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Organized by ',
              style: TextStyle(color: appFontColor()),
            ),
            TextSpan(
              text: model.creatorUsername,
              style: TextStyle(color: appTextButtonColor()),
              recognizer: TapGestureRecognizer()..onTap = () => model.navigateToUserView(cause.creatorID),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseBlockViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initialize(cause.creatorID, cause.imageURLs),
      viewModelBuilder: () => CauseBlockViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => model.navigateToCauseView(cause.id),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 23/24,
              
              
              decoration: BoxDecoration(
                color: appBackgroundColor(),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2.0,
                      spreadRadius: 2.0,
                      // shadow direction: bottom right
                  )
              ],
            ),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  causeHead(model, context),
                  causeImages(model, context),
                  causeDetails(model, context),
                  causeOrganizer(model, context),
                  SizedBox(height: 16.0),
                  Container(),
                ],
              ),
            ),

            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
