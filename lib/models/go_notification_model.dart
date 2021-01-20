import 'package:flutter/material.dart';
import 'package:go/enums/notifcation_type.dart';

class GoNotification {
  String receiverUID;
  String senderUID;
  String type;
  String header;
  String subHeader;
  Map<dynamic, dynamic> additionalData;
  int timePostedInMilliseconds;
  int expDateInMilliseconds;

  GoNotification({
    this.receiverUID,
    this.senderUID,
    this.type,
    this.header,
    this.subHeader,
    this.additionalData,
    this.timePostedInMilliseconds,
    this.expDateInMilliseconds,
  });

  GoNotification.fromMap(Map<String, dynamic> data)
      : this(
          receiverUID: data['receiverUID'],
          senderUID: data['senderUID'],
          type: data['type'],
          header: data['header'],
          subHeader: data['subHeader'],
          additionalData: data['additionalData'],
          timePostedInMilliseconds: data['timePostedInMilliseconds'],
          expDateInMilliseconds: data['expDateInMilliseconds'],
        );

  Map<String, dynamic> toMap() => {
        'receiverUID': this.receiverUID,
        'senderUID': this.senderUID,
        'type': this.type,
        'header': this.header,
        'subHeader': this.subHeader,
        'additionalData': this.additionalData,
        'timePostedInMilliseconds': this.timePostedInMilliseconds,
        'expDateInMilliseconds': this.expDateInMilliseconds,
      };

  GoNotification generateGoCommentNotification({
    @required String postID,
    @required String receiverUID,
    @required String senderUID,
    @required String commenterUsername,
    @required String comment,
  }) {
    GoNotification notif = GoNotification(
      receiverUID: receiverUID,
      senderUID: senderUID,
      type: NotificationType.postComment.toString(),
      header: '$commenterUsername commented on your post',
      subHeader: comment,
      additionalData: {'postID': postID},
      timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      expDateInMilliseconds: DateTime.now().millisecondsSinceEpoch + 7884000000, //Expiration Date Set 3 Months from Now
    );
    return notif;
  }

  GoNotification generateGoFollowUserNotification({
    @required String uid,
    @required String senderUID,
    @required String followerUsername,
  }) {
    GoNotification notif = GoNotification(
      receiverUID: receiverUID,
      senderUID: senderUID,
      type: NotificationType.userFollow.toString(),
      header: 'You have a new follower',
      subHeader: '$followerUsername has started following you',
      additionalData: null,
      timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      expDateInMilliseconds: DateTime.now().millisecondsSinceEpoch + 7884000000, //Expiration Date Set 3 Months from Now
    );
    return notif;
  }

  GoNotification generateGoFollowCauseNotification({
    @required String causeID,
    @required String receiverUID,
    @required String senderUID,
    @required String followerUsername,
    @required String causeName,
  }) {
    GoNotification notif = GoNotification(
      receiverUID: receiverUID,
      senderUID: senderUID,
      type: NotificationType.causeFollow.toString(),
      header: 'Your cause has a new follower',
      subHeader: '$followerUsername has started following $causeName',
      additionalData: {'causeID': causeID},
      timePostedInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      expDateInMilliseconds: DateTime.now().millisecondsSinceEpoch + 7884000000, //Expiration Date Set 3 Months from Now
    );
    return notif;
  }
}