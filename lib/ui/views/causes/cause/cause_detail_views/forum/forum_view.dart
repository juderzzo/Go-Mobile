import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/forum_post/forum_post_view.dart';
import 'package:go/ui/views/x_reusable_template/view_model.dart';
import 'package:stacked/stacked.dart';

class ForumView extends StatelessWidget {
  Widget forumPosts() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        shrinkWrap: true,
        children: [
          ForumPostView(
            postAuthorProfilePicName: "john",
            postAuthorProfilePicURL: "https://source.unsplash.com/random/200x200?sig=1",
          ),
          verticalSpaceMedium,
          ForumPostView(
            postAuthorProfilePicName: "sarah",
            postAuthorProfilePicURL: "https://source.unsplash.com/random/200x200?sig=2",
          ),
          verticalSpaceMedium,
          ForumPostView(
            postAuthorProfilePicName: "michelle",
            postAuthorProfilePicURL: "https://source.unsplash.com/random/200x200?sig=3",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<XViewModel>.reactive(
      viewModelBuilder: () => XViewModel(),
      builder: (context, model, child) => Container(
        child: forumPosts(),
      ),
    );
  }
}
