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
  List interests;
  List inspirations;
  List following;
  List followers;
  List blockedUsers;
  int appOpenTimeInMilliseconds;
  int notifToken;

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
    this.interests,
    this.inspirations,
    this.following,
    this.followers,
    this.blockedUsers,
    this.appOpenTimeInMilliseconds,
    this.notifToken,
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
          interests: data['interests'],
          inspirations: data['inspirations'],
          following: data['following'],
          followers: data['followers'],
          blockedUsers: data['blockedUsers'],
          appOpenTimeInMilliseconds: data['appOpenTimeInMilliseconds'],
          notifToken: data['notifToken'],
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
        'interests': this.interests,
        'inspirations': this.inspirations,
        'following': this.following,
        'followers': this.followers,
        'blockedUsers': this.blockedUsers,
        'appOpenTimeInMilliseconds': this.appOpenTimeInMilliseconds,
        'notifToken': this.notifToken,
      };

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
      interests: ['tag1', 'tag2', 'tag3'],
      inspirations: [],
      followers: [],
      following: [],
      blockedUsers: [],
      appOpenTimeInMilliseconds: null,
      notifToken: null,
    );
    return user;
  }
}
