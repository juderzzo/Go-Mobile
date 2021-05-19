import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'current_user_bottom_sheet_model.dart';

class CurrentUserBottomSheet extends StatelessWidget {
  final SheetRequest? request;
  final Function(SheetResponse)? completer;

  const CurrentUserBottomSheet({
    Key? key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CurrentUserBottomSheetModel>.nonReactive(
      viewModelBuilder: () => CurrentUserBottomSheetModel(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.edit,
                size: 16,
              ),
              height: 45,
              onPressed: () => completer!(SheetResponse(responseData: "edit profile")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Edit Profile",
              textColor: appFontColor(),
              centerContent: false,
            ),
            verticalSpaceSmall,
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.link,
                size: 16,
              ),
              height: 45,
              onPressed: () => completer!(SheetResponse(responseData: "share profile")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Share Profile",
              textColor: appFontColor(),
              centerContent: false,
            ),
            verticalSpaceSmall,
            CustomIconButton(
              icon: Icon(
                FontAwesomeIcons.cog,
                size: 16,
              ),
              height: 45,
              onPressed: () => completer!(SheetResponse(responseData: "settings")),
              backgroundColor: appButtonColor(),
              elevation: 1,
              text: "Settings",
              textColor: appFontColor(),
              centerContent: false,
            ),
          ],
        ),
      ),
    );
  }
}
