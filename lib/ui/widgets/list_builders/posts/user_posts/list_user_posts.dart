import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:stacked/stacked.dart';

import 'list_user_posts_model.dart';

class ListUserPosts extends StatelessWidget {
  final String? id;
  ListUserPosts({required this.id});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListUserPostsModel>.reactive(
      onModelReady: (model) => model.initialize(id),
      viewModelBuilder: () => ListUserPostsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  imageAssetName: "coding",
                  header: "You have created any posts yet",
                  subHeader: "",
                  
                )
              : RefreshIndicator(
                  onRefresh: model.refreshData,
                  backgroundColor: appBackgroundColor(),
                  child: ListView.builder(
                    key: PageStorageKey(model.listKey),
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    itemCount: model.dataResults.length + 1,
                    itemBuilder: (context, index) {
                      if (index < model.dataResults.length) {
                        GoForumPost post;
                        bool displayBottomBorder = true;

                        ///GET CAUSE OBJECT
                        post = GoForumPost.fromMap(model.dataResults[index].data()!);

                        ///DISPLAY BOTTOM BORDER
                        if (model.dataResults.last == model.dataResults[index]) {
                          displayBottomBorder = false;
                        }
                        return ForumPostBlockView(
                          post: post,
                          displayBottomBorder: displayBottomBorder,
                        );
                      } else {
                        if (model.moreDataAvailable) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            model.loadAdditionalData();
                          });
                          return Align(
                            alignment: Alignment.center,
                            child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ),
    );
  }
}
