import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/page_models/home_page_models/screen_models/explore_screen_model.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget head() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Explore",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          IconButton(
            onPressed: null,
            icon: Icon(FontAwesomeIcons.plus, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return GoExplorePageTabBar(
      tabController: _tabController,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ExploreScreenModel>.withConsumer(
      viewModelBuilder: () => ExploreScreenModel(),
      builder: (context, model, child) => Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                head(),
                SizedBox(height: 8),
                tabBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
