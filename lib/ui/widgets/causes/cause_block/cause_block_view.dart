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

  Widget causeHead(CauseBlockViewModel model) {
    return Container(
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
            onPressed: () => model.showOptions(),
          ),
        ],
      ),
    );
  }

  Widget causeImages(CauseBlockViewModel model) {
    return model.isLoading
        ? Container()
        : SizedBox(
            height: 300,
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

  Widget causeDetails(CauseBlockViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
            cause.why,
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
            cause.goal,
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

  Widget causeOrganizer(CauseBlockViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              causeHead(model),
              causeImages(model),
              causeDetails(model),
              causeOrganizer(model),
              SizedBox(height: 16.0),
              displayBottomBorder
                  ? Divider(
                      thickness: 8.0,
                      color: appPostBorderColor(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
