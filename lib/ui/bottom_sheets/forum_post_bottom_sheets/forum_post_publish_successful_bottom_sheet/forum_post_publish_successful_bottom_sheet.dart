import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'forum_post_publish_successful_bottom_sheet_model.dart';

class ForumPostSuccessfulBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const ForumPostSuccessfulBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumPostSuccessfulBottomSheetModel>.nonReactive(
      viewModelBuilder: () => ForumPostSuccessfulBottomSheetModel(),
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
              text: "Post Published!",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
            verticalSpaceTiny,
            CustomText(
              text: "Don't Forget to Share it!",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appFontColorAlt(),
            ),
            verticalSpaceMedium,
            CustomTextButton(
              onTap: () => model.sharePostLink(request!.customData),
              text: "Share",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: appTextButtonColor(),
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
