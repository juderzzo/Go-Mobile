import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'cause_publish_successful_bottom_sheet_model.dart';

class CausePublishSuccessfulBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const CausePublishSuccessfulBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CausePublishSuccessfulBottomSheetModel>.nonReactive(
      viewModelBuilder: () => CausePublishSuccessfulBottomSheetModel(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: appBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceSmall,
            CustomText(
              text: "Cause Under Review",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
            verticalSpaceTiny,
            CustomText(
              text: "Upon acceptance, your cause will be visible in your homepage.\nReview times typically take less than 24 hours",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appFontColorAlt(),
            ),
            verticalSpaceMedium,
            CustomButton(
              onPressed: () => completer!(SheetResponse(responseData: "return")),
              text: "Done",
              textSize: 16,
              textColor: appFontColor(),
              height: 45,
              width: screenWidth(context),
              backgroundColor: appButtonColorAlt(),
              elevation: 1.0,
              isBusy: false,
            ),
          ],
        ),
      ),
    );
  }
}
