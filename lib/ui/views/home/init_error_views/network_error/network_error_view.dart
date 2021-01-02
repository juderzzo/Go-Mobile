import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';

import 'network_error_view_model.dart';

class NetworkErrorView extends StatelessWidget {
  final VoidCallback tryAgainAction;
  NetworkErrorView({@required this.tryAgainAction});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NetworkErrorViewModel>.nonReactive(
      disposeViewModel: true,
      viewModelBuilder: () => NetworkErrorViewModel(),
      builder: (context, model, child) => Container(
        color: appBackgroundColor(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: screenHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You're Not Connected to the Internet.\nPlease Find a Stable Connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appFontColor(),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            CustomButton(
              elevation: 1,
              text: 'Try Again',
              textColor: appFontColor(),
              backgroundColor: appBackgroundColor(),
              isBusy: false,
              height: 50,
              width: screenWidth(context),
              onPressed: tryAgainAction,
            ),
          ],
        ),
      ),
    );
  }
}
