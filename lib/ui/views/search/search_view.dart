import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/search/search_view_model.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_causes_search_results.dart';
import 'package:go/ui/widgets/list_builders/list_recent_search_results.dart';
import 'package:go/ui/widgets/list_builders/list_user_search_results.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  Widget head(SearchViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
            heroTag: 'search',
            onTap: null,
            enabled: true,
            textEditingController: model.searchTextController,
            onChanged: (val) => model.querySearchResults(val),
            onFieldSubmitted: (val) => print('submitted'),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => model.navigateToPreviousPage(),
            child: CustomText(
              text: "Cancel",
              textAlign: TextAlign.right,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: appTextButtonColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget listResults(SearchViewModel model) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          listCausesResults(model),
          listUserResults(model),
        ],
      ),
    );
  }

  Widget listRecentResults(SearchViewModel model) {
    return ListRecentSearchResults(
      searchTerms: model.recentSearchTerms,
      scrollController: null,
      isScrollable: false,
    );
  }

  Widget listCausesResults(SearchViewModel model) {
    return ListCausesSearchResults(
      results: model.causeResults,
      scrollController: null,
      isScrollable: false,
    );
  }

  Widget listUserResults(SearchViewModel model) {
    return ListUsersSearchResults(
      results: model.userResults,
      scrollController: null,
      isScrollable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) => Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: screenHeight(context),
            color: appBackgroundColor(),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    head(model),
                    SizedBox(height: 8),
                    listResults(model),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
