import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'check_list_item_form_view_model.dart';

class CheckListItemFormView extends StatelessWidget {
  final GoCheckListItem item;
  final Function(GoCheckListItem) onDelete;
  final Function(GoCheckListItem) onSave;

  CheckListItemFormView({
    required this.item,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListItemFormViewModel>.reactive(
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initialize(item),
      viewModelBuilder: () => CheckListItemFormViewModel(),
      builder: (context, model, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: screenWidth(context),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderField(),
              verticalSpaceSmall,
              _SubHeaderField(),
              verticalSpaceSmall,
              model.requiresLocationVerification ? _LocationField() : Container(),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  model.requiresLocationVerification
                      ? CustomTextButton(
                          onTap: () => model.toggleRequiresLocationVerification(),
                          text: 'Remove Location',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: appTextButtonColor(),
                        )
                      : CustomTextButton(
                          onTap: () {
                            model.toggleRequiresLocationVerification();
                          },
                          text: 'Add Location',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: appTextButtonColor(),
                        ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1/4,
                  ),
                  _ItemPointsDropDown(),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  CustomTextButton(
                    onTap: () => onSave(model.saveItem()),
                    text: 'Save Item',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appTextButtonColor(),
                  ),
                  horizontalSpaceMedium,
                  CustomTextButton(
                    onTap: () => onDelete(item),
                    text: 'Delete Item',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appDestructiveColor(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderField extends HookViewModelWidget<CheckListItemFormViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CheckListItemFormViewModel model) {
    final _textController = useTextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (model.checkListItem.isValid() && model.loadedPreviousHeader == false) {
        _textController.text = model.loadPreviousHeader();
      }
    });

    return SingleLineTextField(
      controller: _textController,
      hintText: "Action",
      textLimit: 20,
      isPassword: false,
      onChanged: (val) {
        model.updateHeader(val);
        _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
      },
    );
  }
}

class _SubHeaderField extends HookViewModelWidget<CheckListItemFormViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CheckListItemFormViewModel model) {
    final _textController = useTextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (model.checkListItem.isValid() && model.loadedPreviousSubHeader == false) {
        _textController.text = model.loadPreviousSubHeader();
      }
    });

    return MultiLineTextField(
      controller: _textController,
      hintText: "Description",
      maxLines: 2,
      enabled: true,
      initialValue: null,
      onChanged: (val) {
        model.updateSubHeader(val);
        _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
      },
    );
  }
}

class _ItemPointsDropDown extends HookViewModelWidget<CheckListItemFormViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CheckListItemFormViewModel model) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextButton(
            onTap: () {},
            text: 'Reward: ',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          DropdownButton<int>(
            value: model.checkListItem.points ?? 0,
            iconSize: 0,
            elevation: 16,
            style: TextStyle(
              color: appTextButtonColor(),
              fontWeight: FontWeight.bold,
            ),
            underline: Container(
              color: appTextFieldContainerColor(),
            ),
            onChanged: (val) => model.updatePoints(val!),
            items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value points"),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LocationField extends HookViewModelWidget<CheckListItemFormViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CheckListItemFormViewModel model) {
    final _textController = useTextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (model.checkListItem.isValid() && model.loadedPreviousSubHeader == false) {
        _textController.text = model.loadPreviousSubHeader();
      }
    });

    return TextFieldContainer(
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
          Map<String, dynamic> res = await model.googlePlacesService!.googleSearchAutoComplete(input: searchTerm);
          model.setPlacesSearchResults(res);
          return model.placeSearchResults.keys.toList();
        },
        itemBuilder: (context, dynamic place) {
          return ListTile(
            title: Text(
              place,
              style: TextStyle(color: appFontColor(), fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          );
        },
        onSuggestionSelected: (dynamic val) async {
          Map<String, dynamic> details = await model.getPlaceDetails(val);
          model.updateLocation(details['lat'], details['lon'], details['address']);
        },
      ),
    );
  }
}
