import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/views/home/search_field/search_field_view_model.dart';
import 'package:stacked/stacked.dart';

class SearchFieldView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchFieldViewModel>.reactive(
      viewModelBuilder: () => SearchFieldViewModel(),
      builder: (context, model, child) => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 8),
          height: 35,
          decoration: BoxDecoration(
            color: appTextFieldContainerColor(),
            border: Border.all(
              width: 1.0,
              color: appBorderColorAlt(),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              Container(
                child: Icon(
                  FontAwesomeIcons.search,
                  color: appFontColorAlt(),
                  size: 16,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: TypeAheadField(
                    hideOnEmpty: true,
                    hideOnLoading: true,
                    direction: AxisDirection.up,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: null,
                      cursorColor: appFontColorAlt(),
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "search",
                        border: InputBorder.none,
                      ),
                      autofocus: false,
                    ),
                    suggestionsCallback: (searchTerm) async {
                      return null;
                      // Map<String, dynamic> res = await model.googlePlacesService.googleSearchAutoComplete(key: model.googleAPIKey, input: searchTerm);
                      // model.setPlacesSearchResults(res);
                      // return model.placeSearchResults.keys.toList();
                    },
                    itemBuilder: (context, place) {
                      return ListTile(
                        title: Text(
                          place,
                          style: TextStyle(
                            color: appFontColor(),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected:
                        (val) {}, //(val) => model.getPlaceDetails(val),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
