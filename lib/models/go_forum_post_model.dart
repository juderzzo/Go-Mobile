class GoForumPost {
  String? id;
  String? causeID;
  String? authorID;
  String? imageID;
  int? dateCreatedInMilliseconds;
  String? body;
  int? commentCount;
  List? likedBy;
  List? followers;

  GoForumPost({
    this.id,
    this.causeID,
    this.authorID,
    this.dateCreatedInMilliseconds,
    this.body,
    this.commentCount,
    this.imageID,
    this.likedBy,
    this.followers,
  });

  GoForumPost.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          causeID: data['causeID'],
          authorID: data['authorID'],
          dateCreatedInMilliseconds: data['dateCreatedInMilliseconds'],
          body: data['body'],
          commentCount: data['commentCount'],
          imageID: data['imageID'],
          likedBy: data['likedBy'],
          followers: data['followers'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'causeID': this.causeID,
        'authorID': this.authorID,
        'dateCreatedInMilliseconds': this.dateCreatedInMilliseconds,
        'body': this.body,
        'commentCount': this.commentCount,
        'imageID': this.imageID,
        'likedBy': this.likedBy,
        'followers': this.followers,
      };

  //checks if obj is valid
  bool isValid() {
    bool isValid = true;
    if (id == null) {
      isValid = false;
    }
    return isValid;
  }
}
