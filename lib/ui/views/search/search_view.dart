import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/search/search_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/list_builders/list_causes_search_results.dart';
import 'package:go/ui/widgets/list_builders/list_recent_search_results.dart';
import 'package:go/ui/widgets/list_builders/list_user_search_results.dart';
import 'package:go/ui/widgets/search/search_field.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  Widget head(SearchViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget causesHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: "Causes",
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
        fontSize: 24,
        color: appFontColorAlt(),
      ),
    );
  }

  Widget usersHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomText(
        text: "Changemakers",
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
        fontSize: 24,
        color: appFontColorAlt(),
      ),
    );
  }

  Widget causeUserSearchDivider(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 16,
          width: screenWidth(context),
          color: appTextFieldContainerColor(),
        ),
        verticalSpaceSmall,
      ],
    );
  }

  Widget listResults(BuildContext context, SearchViewModel model) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          model.causeResults.isNotEmpty ? listCausesResults(model) : Container(),
          model.causeResults.isNotEmpty && model.userResults.isNotEmpty ? causeUserSearchDivider(context) : Container(),
          model.userResults.isNotEmpty ? listUserResults(model) : Container(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        causesHeader(),
        ListCausesSearchResults(
          results: model.causeResults,
          scrollController: null,
          isScrollable: false,
        ),
      ],
    );
  }

  Widget listUserResults(SearchViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        usersHeader(),
        ListUsersSearchResults(
          results: model.userResults,
          scrollController: null,
          isScrollable: false,
        ),
      ],
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
                child: Column(
                  children: [
                    head(model),
                    verticalSpaceSmall,
                    model.isBusy ? CustomLinearProgressIndicator(color: appActiveColor()) : Container(),
                    SizedBox(height: 8),
                    listResults(context, model),
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
