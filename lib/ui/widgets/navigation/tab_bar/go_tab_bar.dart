import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';

class GoExplorePageTabBar extends StatelessWidget {
  final TabController tabController;
  GoExplorePageTabBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(bottom: 4),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: CustomColors.goGreen,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.goGreen),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Causes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Changemakers",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoCauseViewTabBar extends StatelessWidget {
  final TabController tabController;
  GoCauseViewTabBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(bottom: 8),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: CustomColors.goGreen,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.goGreen),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Today's Check List",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Forum",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoProfileTabBar extends StatelessWidget {
  final TabController tabController;
  GoProfileTabBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    FontWeight fontWeight = FontWeight.w600;
    return Container(
      height: 35,
      padding: EdgeInsets.only(bottom: 8),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: CustomColors.goGreen, //appActiveColor(),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54, //appInActiveColorAlt(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.goGreen, //appActiveColor(),
        ),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Posts",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Streams",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Events",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Check-Ins",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
