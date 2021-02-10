import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';

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
        indicatorColor: appActiveColor(),
        labelColor: Colors.white,
        unselectedLabelColor: appInActiveColorAlt(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appActiveColor(),
        ),
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
      height: 35,
      padding: EdgeInsets.only(bottom: 8),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: appActiveColor(),
        labelColor: Colors.white,
        unselectedLabelColor: appInActiveColorAlt(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appActiveColor(),
        ),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 100,
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
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Check List",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 100,
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
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
        indicatorColor: appActiveColor(),
        labelColor: Colors.white,
        unselectedLabelColor: appInActiveColorAlt(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appActiveColor(),
        ),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Bio",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Causes",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "My Causes",
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



class GoProfilePageTabBar extends StatelessWidget {
  final TabController tabController;
  GoProfilePageTabBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    FontWeight fontWeight = FontWeight.w600;
    return Container(
      height: 35,
      padding: EdgeInsets.only(bottom: 8),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
        indicatorColor: appActiveColor(),
        labelColor: Colors.white,
        unselectedLabelColor: appInActiveColorAlt(),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appActiveColor(),
        ),
        tabs: [
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Liked",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Causes",
                  style: TextStyle(fontWeight: fontWeight),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "My Causes",
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

