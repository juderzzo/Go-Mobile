import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/search_results_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/search/search_result_view.dart';

class ListUsersSearchResults extends StatelessWidget {
  final Function(String) onSearchTermSelected;
  final List<SearchResult> results;
  final ScrollController scrollController;
  final bool isScrollable;
  Function addAdmin;

  ListUsersSearchResults({@required this.onSearchTermSelected, @required this.results, @required this.isScrollable, @required this.scrollController, this.addAdmin});

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
        //print('add admin' + '${addAdmin == null}');
        return UserSearchResultView(
          onTap: () => onSearchTermSelected(results[index].id),
          searchResult: results[index],
          isFollowing: false,
          displayBottomBorder: index == results.length - 1 ? false : true,
          addAdmin: addAdmin,
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
