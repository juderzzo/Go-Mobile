import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';
import 'package:stacked/stacked.dart';

import 'check_list_item_form_view_model.dart';

class CheckListItemFormView extends StatelessWidget {
  final GoCheckListItem item;
  final Function(Map<String, dynamic>) onChangedHeader;
  final Function(Map<String, dynamic>) onChangedSubHeader;
  final Function(Map<String, dynamic>) onSetLocation;
  final Function(String) onDelete;
  final Function(String) onRemoveLocation;

  CheckListItemFormView({
    @required this.item,
    @required this.onChangedHeader,
    @required this.onChangedSubHeader,
    @required this.onSetLocation,
    @required this.onDelete,
    @required this.onRemoveLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListItemFormViewModel>.reactive(
      onModelReady: (model) => model.initialize(item),
      viewModelBuilder: () => CheckListItemFormViewModel(),
      builder: (context, model, child) => Container(
        padding: EdgeInsets.fromLTRB(32.0, 10.0, 0.0, 0.0),
        height: 210,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: appTextFieldContainerColor(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleLineTextField(
                      initialValue: item.header,
                      controller: null,
                      hintText: "Action",
                      textLimit: 20,
                      isPassword: false,
                      onChanged: (val) => onChangedHeader({
                        'id': item.id,
                        'header': val,
                      }),
                      onSubmitted: null,
                    )),
                verticalSpaceSmall,
                Container(
                  decoration: BoxDecoration(
                    color: appTextFieldContainerColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  child: MultiLineTextField(
                    initialValue: item.subHeader,
                    controller: null,
                    hintText: "Description",
                    maxLines: 2,
                    onChanged: (val) => onChangedSubHeader({
                      'id': item.id,
                      'subHeader': val,
                    }),
                    onSubmitted: null,
                  ),
                ),
                verticalSpaceSmall,
                model.requiresLocationVerification
                    ? TextFieldContainer(
                        height: 38,
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: TypeAheadField(
                            hideOnEmpty: true,
                            hideOnLoading: true,
                            direction: AxisDirection.up,
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: model.locationTextController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintText: "Search for Address",
                                border: InputBorder.none,
                              ),
                              autofocus: false,
                            ),
                            suggestionsCallback: (searchTerm) async {
                              Map<String, dynamic> res = await model.googlePlacesService.googleSearchAutoComplete(input: searchTerm);
                              model.setPlacesSearchResults(res);
                              return model.placeSearchResults.keys.toList();
                            },
                            itemBuilder: (context, place) {
                              return ListTile(
                                title: Text(
                                  place,
                                  style: TextStyle(color: appFontColor(), fontSize: 14.0, fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                            onSuggestionSelected: (val) async {
                              Map<String, dynamic> details = await model.getPlaceDetails(val);
                              onSetLocation({
                                'id': item.id,
                                'lat': details['lat'],
                                'lon': details['lon'],
                                'address': details['address'],
                              });
                            },
                          ),
                        ),
                      )
                    : Container(),
                verticalSpaceSmall,
                model.requiresLocationVerification
                    ? CustomTextButton(
                        onTap: () {
                          model.toggleRequiresLocationVerification();
                          onRemoveLocation(item.id);
                        },
                        text: 'Remove Location',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: appTextButtonColor(),
                      )
                    : CustomTextButton(
                        onTap: () {
                          model.toggleRequiresLocationVerification();
                        },
                        text: 'Add Location',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: appTextButtonColor(),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 75.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                child: GestureDetector(
                  onTap: () => onDelete(item.id),
                  child: Icon(
                    Icons.remove,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
