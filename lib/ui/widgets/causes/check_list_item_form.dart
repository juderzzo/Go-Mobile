import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';

class CheckListItemForm extends StatelessWidget {
  final GoCheckListItem item;
  final Function(Map<String, dynamic>) onChangedHeader;
  final Function(Map<String, dynamic>) onChangedSubHeader;
  final Function(Map<String, dynamic>) onSetLocation;
  final Function(String) onDelete;

  CheckListItemForm({
    @required this.item,
    @required this.onChangedHeader,
    @required this.onChangedSubHeader,
    @required this.onSetLocation,
    @required this.onDelete,
  });

  //we need an index and and id to have the cause
  //CheckField({this.id, this.header, this.subheader, this.index});
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32.0, 10.0, 0.0, 0.0),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Column(children: [
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
          ]),
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
    );
  }
}
