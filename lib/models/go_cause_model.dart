import 'package:go/utils/custom_string_methods.dart';

class GoCause {
  String? id;
  String? creatorID;
  int? dateCreatedInMilliseconds;
  String? name;
  String? goal;
  String? why;
  String? who;
  String? resources;
  String? charityURL;
  List? imageURLs;
  List? actions;
  List? followers;
  List? admins;
  int? followerCount;
  int? forumPostCount;
  String? website;
  String? videoLink;
  bool? monetized;
  int? revenue;
  bool? approved;

  GoCause(
      {this.id,
      this.creatorID,
      this.dateCreatedInMilliseconds,
      this.name,
      this.goal,
      this.why,
      this.who,
      this.resources,
      this.charityURL,
      this.imageURLs,
      this.actions,
      this.followers,
      this.admins,
      this.followerCount,
      this.forumPostCount,
      this.website,
      this.videoLink,
      this.monetized,
      this.revenue,
      this.approved});

  GoCause.fromMap(Map<String, dynamic> data)
      : this(
            id: data['id'],
            creatorID: data['creatorID'],
            dateCreatedInMilliseconds: data['dateCreatedInMilliseconds'],
            name: data['name'],
            goal: data['goal'],
            why: data['why'],
            who: data['who'],
            resources: data['resources'],
            charityURL: data['charityURL'],
            imageURLs: data['imageURLs'],
            actions: data['actions'],
            followers: data['followers'],
            followerCount: data['followerCount'],
            forumPostCount: data['forumPostCount'],
            admins: data['admins'],
            website: data['website'],
            videoLink: data['videoLink'],
            monetized: data['monetized'],
            revenue: data['revenue'],
            approved: data['approved']);

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'creatorID': this.creatorID,
        'dateCreatedInMilliseconds': this.dateCreatedInMilliseconds,
        'name': this.name,
        'goal': this.goal,
        'why': this.why,
        'who': this.who,
        'resources': this.resources,
        'charityURL': this.charityURL,
        'imageURLs': this.imageURLs,
        'actions': this.actions,
        'followers': this.followers,
        'followerCount': this.followerCount,
        'forumPostCount': this.forumPostCount,
        'admins': this.admins,
        'website': this.website,
        'videoLink': this.videoLink,
        'monetized': this.monetized,
        'revenue': this.revenue,
        'approved': this.approved
      };

  GoCause generateNewCause({required String creatorID}) {
    GoCause cause = GoCause(
        id: getRandomString(35),
        creatorID: creatorID,
        dateCreatedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
        imageURLs: [],
        admins: [creatorID],
        followers: [creatorID],
        followerCount: 1,
        forumPostCount: 0,
        revenue: 0,
        monetized: false,
        approved: false);
    return cause;
  }

  //checks if obj is valid
  bool isValid() {
    bool isValid = true;
    if (id == null) {
      isValid = false;
    }
    return isValid;
  }
}
