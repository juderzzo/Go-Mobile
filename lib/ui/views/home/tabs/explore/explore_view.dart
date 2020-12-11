import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/ui/views/home/tabs/explore/explore_view_model.dart';
import 'package:go/ui/widgets/navigation/tab_bar/go_tab_bar.dart';
import 'package:stacked/stacked.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> with SingleTickerProviderStateMixin {
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
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
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
