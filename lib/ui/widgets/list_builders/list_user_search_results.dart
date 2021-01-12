import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/search/search_result_view.dart';

class ListUsersSearchResults extends StatelessWidget {
  final List<SearchResult> results;
  final ScrollController scrollController;
  final bool isScrollable;

  ListUsersSearchResults({@required this.results, @required this.isScrollable, @required this.scrollController});

  Widget listResults() {
    return ListView.builder(
      controller: scrollController,
      physics: isScrollable ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      padding: EdgeInsets.only(
        top: 4.0,
        bottom: 4.0,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return UserSearchResultView(
          onTap: null,
          searchResult: results[index],
          isFollowing: false,
          displayBottomBorder: index == results.length - 1 ? false : true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isScrollable
        ? Container(
            height: screenHeight(context),
            color: appBackgroundColor(),
            child: listResults(),
          )
        : listResults();
  }
}
