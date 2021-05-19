import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/bottom_sheets/forum_post_bottom_sheets/forum_post_bottom_sheet/forum_post_bottom_sheet_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForumPostBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const ForumPostBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostBottomSheetModel>.nonReactive(
      viewModelBuilder: () => ForumPostBottomSheetModel(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "share")),
              text: "Share",
              textSize: 16,
              textColor: appFontColor(),
              height: 45,
              width: screenWidth(context),
              backgroundColor: appBackgroundColor(),
              elevation: 1.0,
              isBusy: false,
            ),
            verticalSpaceSmall,
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "report")),
              text: "Report",
              textSize: 16,
              textColor: appDestructiveColor(),
              height: 45,
              width: screenWidth(context),
              backgroundColor: appBackgroundColor(),
              elevation: 1.0,
              isBusy: false,
            ),
          ],
        ),
      ),
    );
  }
}
