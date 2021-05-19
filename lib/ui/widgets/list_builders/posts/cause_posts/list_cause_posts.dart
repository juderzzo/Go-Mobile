import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:stacked/stacked.dart';

import 'list_cause_posts_model.dart';

class ListCausePosts extends StatelessWidget {
  final String causeID;
  ListCausePosts({required this.causeID});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListCausePostsModel>.reactive(
      onModelReady: (model) => model.initialize(causeID),
      viewModelBuilder: () => ListCausePostsModel(),
      builder: (context, model, child) => model.isBusy
          ? Container()
          : model.dataResults.isEmpty
              ? ZeroStateView(
                  imageAssetName: "coding",
                  header: "No Posts Found",
                  subHeader: "Make the first cause post",
                  mainActionButtonTitle: "Create Post",
                  mainAction: () => model.navigateToCreatePostView(causeID),
                  // secondaryActionButtonTitle: null,
                  // secondaryAction: null,
                )
              : Container(
                  height: screenHeight(context),
                  color: appBackgroundColor(),
                  child: RefreshIndicator(
                    onRefresh: model.refreshData,
                    backgroundColor: appBackgroundColor(),
                    child: RefreshIndicator(
                      onRefresh: model.refreshData,
                      backgroundColor: appBackgroundColor(),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: model.scrollController,
                        // key: UniqueKey(),
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

                            ///GET POST OBJECT
                            post = GoForumPost.fromMap(model.dataResults[index].data()!);

                            ///DISPLAY BOTTOM BORDER
                            if (model.dataResults.last == model.dataResults[index]) {
                              displayBottomBorder = false;
                            }
                            return ForumPostBlockView(
                              refreshAction: null,
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
                  ),
                ),
    );
  }
}
