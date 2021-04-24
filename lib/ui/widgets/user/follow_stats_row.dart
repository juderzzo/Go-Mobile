import 'package:flutter/material.dart';

class FollowStatsRow extends StatelessWidget {
  final int? followersLength;
  final int? followingLength;
  final VoidCallback? viewFollowersAction;
  final VoidCallback? viewFollowingAction;
  final int? points;

  FollowStatsRow({
    this.followersLength,
    this.followingLength,
    this.viewFollowersAction,
    this.viewFollowingAction,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: viewFollowersAction,
            child: Column(
              children: [
                Text(
                  followersLength.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Followers",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 32.0),
          GestureDetector(
            onTap: viewFollowingAction,
            child: Column(
              children: [
                Text(
                  followingLength.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Following",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 32.0),
          GestureDetector(
            //onTap: viewFollowingAction,
            child: Column(
              children: [
                Text(
                  points.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "   Points  ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
