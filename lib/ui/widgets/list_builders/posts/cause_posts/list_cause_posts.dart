import 'package:cloud_firestore/cloud_firestore.dart';
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
      builder: (context, model, child) => RefreshIndicator(
                      onRefresh: () async {
                        await model.initialize(causeID);
                      },
                      backgroundColor: appBackgroundColor(),
                      child: model.builder 
    )
    );
  }
}
