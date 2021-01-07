import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/views/causes/cause_block/cause_block_view_model.dart';
import 'package:stacked/stacked.dart';

class CauseBlockView extends StatelessWidget {
  final GoCause cause;

  CauseBlockView({this.cause});

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
            onPressed: null,
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
              recognizer: TapGestureRecognizer()..onTap = null,
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
              Divider(
                thickness: 8.0,
                color: appPostBorderColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
