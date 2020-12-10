import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/page_models/home_page_models/screen_models/home_screen_model.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class HomeScreen extends StatelessWidget {
  Widget head() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Home",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(FontAwesomeIcons.slidersH, color: Colors.black, size: 20),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(FontAwesomeIcons.plus, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeScreenModel>.withConsumer(
      onModelReady: (model) {},
      viewModelBuilder: () => HomeScreenModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                head(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
