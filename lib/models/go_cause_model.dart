class GoCause {
  String id;
  String creatorID;
  int dateCreatedInMilliseconds;
  String name;
  String goal;
  String why;
  String who;
  String resources;
  String charityURL;
  List imageURLs;
  List actions;
  List followers;
  List actionDescriptions;
  int followerCount;
  int forumPostCount;
  String videoLink;

  GoCause({
    this.id,
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
    this.actionDescriptions,
    this.followerCount,
    this.forumPostCount,
    this.videoLink,
  });

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
          actionDescriptions: data['actionDescriptions'],
          videoLink: data['videoLink']
        );

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
        'actionDescriptions': this.actionDescriptions,
        'videoLink': this.videoLink
      };

  GoCause generateDummyCause(String id) {
    GoCause cause = GoCause();
    return cause;
  }
}
