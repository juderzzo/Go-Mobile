import 'package:flutter/material.dart';
import 'package:go/ui/views/x_reusable_template/view_model.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:stacked/stacked.dart';

class ForumView extends StatelessWidget {
  Widget forumPosts() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        shrinkWrap: true,
        children: [
          ForumPostBlockView(
            postAuthorProfilePicName: "john",
            postAuthorProfilePicURL: "https://source.unsplash.com/random/200x200?sig=1",
          ),
          ForumPostBlockView(
            postAuthorProfilePicName: "sarah",
            postAuthorProfilePicURL: "https://source.unsplash.com/random/200x200?sig=2",
          ),
          ForumPostBlockView(
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
