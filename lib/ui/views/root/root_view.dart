import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:stacked/stacked.dart';

import 'root_view_model.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(isDarkMode() ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    return ViewModelBuilder<RootViewModel>.reactive(
      viewModelBuilder: () => RootViewModel(),
      onModelReady: (model) => model.checkAuthState(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/images/go_logo.png',
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                SizedBox(height: 32.0),
                CustomCircleProgressIndicator(
                  color: Colors.black54,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
