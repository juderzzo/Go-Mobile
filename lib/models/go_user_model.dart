import 'package:flutter/material.dart';

class GoUser {
  String id;
  String fbID;
  String googleID;
  String email;
  String phoneNo;
  String username;
  String profilePicURL;
  String bio;
  String personalSite;
  List checks;
  List inspirations;
  int followerCount;
  int followingCount;
  List following;
  List followers;
  List liked;
  List blockedUsers;
  int appOpenTimeInMilliseconds;
  String messageToken;

  GoUser({
    this.id,
    this.fbID,
    this.googleID,
    this.email,
    this.phoneNo,
    this.username,
    this.profilePicURL,
    this.bio,
    this.personalSite,
    this.checks,
    this.inspirations,
    this.followerCount,
    this.followingCount,
    this.following,
    this.followers,
    this.liked,
    this.blockedUsers,
    this.appOpenTimeInMilliseconds,
    this.messageToken,
  });

  GoUser.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          fbID: data['fbID'],
          googleID: data['googleID'],
          email: data['email'],
          phoneNo: data['phoneNo'],
          username: data['username'],
          profilePicURL: data['profilePicURL'],
          bio: data['bio'],
          personalSite: data['personalSite'],
          checks: data['checks'],
          inspirations: data['inspirations'],
          followerCount: data['followerCount'],
          followingCount: data['followingCount'],
          following: data['following'],
          followers: data['followers'],
          liked: data['liked'],
          blockedUsers: data['blockedUsers'],
          appOpenTimeInMilliseconds: data['appOpenTimeInMilliseconds'],
          messageToken: data['messageToken'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'fbID': this.fbID,
        'googleID': this.googleID,
        'email': this.email,
        'phoneNo': this.phoneNo,
        'username': this.username,
        'profilePicURL': this.profilePicURL,
        'bio': this.bio,
        'personalSite': this.personalSite,
        'checks': this.checks,
        'inspirations': this.inspirations,
        'followerCount': this.followerCount,
        'followingCount': this.followingCount,
        'following': this.following,
        'followers': this.followers,
        'blockedUsers': this.blockedUsers,
        'liked': this.liked,
        'appOpenTimeInMilliseconds': this.appOpenTimeInMilliseconds,
        'messageToken': this.messageToken,
      };

  GoUser generateNewUser({
    @required String id,
    @required String fbID,
    @required String googleID,
    @required String email,
    @required String phoneNo,
  }) {
    GoUser user = GoUser(
      id: id,
      fbID: fbID,
      googleID: googleID,
      email: email,
      phoneNo: phoneNo,
      username: id.substring(0, 10),
      profilePicURL: "https://picsum.photos/200",
      bio: "",
      personalSite: "",
      checks: [],
      inspirations: [],
      followerCount: 0,
      followingCount: 0,
      followers: [],
      following: [],
      liked: [],
      blockedUsers: [],
      appOpenTimeInMilliseconds: null,
      messageToken: null,
    );
    return user;
  }

  ///TESTING
  GoUser generateDummyUserFromID(String id) {
    GoUser user = GoUser(
      id: id,
      fbID: null,
      googleID: null,
      email: null,
      phoneNo: "+1 701-200-1000",
      username: id.substring(0, 10),
      profilePicURL: "https://picsum.photos/200",
      bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
          "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
          "nisi ut aliquip ex ea commodo consequat.",
      personalSite: "https://google.com",
      checks: ['tag1', 'tag2', 'tag3'],
      inspirations: [],
      followerCount: 0,
      followingCount: 0,
      followers: [],
      following: [],
      liked: [],
      blockedUsers: [],
      appOpenTimeInMilliseconds: null,
      messageToken: null,
    );
    return user;
  }
}
