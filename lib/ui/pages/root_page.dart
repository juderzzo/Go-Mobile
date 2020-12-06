import 'package:flutter/material.dart';
import 'package:go/page_models/root_page_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RootPageModel>.withConsumer(
      viewModelBuilder: () => RootPageModel(),
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
                  child: Image.asset('assets/images/go_logo.png'),
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
