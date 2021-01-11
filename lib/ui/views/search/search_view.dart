import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/search/search_view_model.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/search_field/search_field_view.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  Widget head(SearchViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchFieldView(
            heroTag: 'search',
            onTap: null,
            enabled: true,
            textEditingController: null,
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
