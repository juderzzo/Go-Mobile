class GoForumPost {
  String id;
  String causeID;
  String authorID;
  int dateCreatedInMilliseconds;
  String body;
  int replyCount;

  GoForumPost({
    this.id,
    this.causeID,
    this.authorID,
    this.dateCreatedInMilliseconds,
    this.body,
    this.replyCount,
  });

  GoForumPost.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          causeID: data['causeID'],
          authorID: data['authorID'],
          dateCreatedInMilliseconds: data['dateCreatedInMilliseconds'],
          body: data['body'],
          replyCount: data['replyCount'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'causeID': this.causeID,
        'authorID': this.authorID,
        'dateCreatedInMilliseconds': this.dateCreatedInMilliseconds,
        'body': this.body,
        'replyCount': this.replyCount,
      };
}
