import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item_form/check_list_item_form_view.dart';

class ListCheckListItemsForEditing extends StatelessWidget {
  final List<GoCheckListItem> items;
  final VoidCallback refreshData;
  final Key pageStorageKey;
  final ScrollController? scrollController;
  final Function(Map<String, dynamic>) onChangedHeader;
  final Function(Map<String, dynamic>) onChangedSubHeader;
  final Function(Map<String, dynamic>) onSetLocation;
  final Function(Map<String, dynamic>) onSetPoints;
  final Function(String) onDelete;
  final Function(String) onRemoveLocation;

  ListCheckListItemsForEditing({
    required this.refreshData,
    required this.items,
    required this.pageStorageKey,
    required this.scrollController,
    required this.onChangedHeader,
    required this.onChangedSubHeader,
    required this.onSetLocation,
    required this.onDelete,
    required this.onRemoveLocation,
    required this.onSetPoints,
  });

  void printItems() {
    String ans = "";
    items.forEach((element) {
      ans += " ,";
      ans += " ${element.header}";
    });
    print(ans);
  }

  Widget listCauses() {
    return RefreshIndicator(
      onRefresh: refreshData as Future<void> Function(),
      backgroundColor: appBackgroundColor(),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        key: pageStorageKey,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 4.0,
          bottom: 4.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          //print(items[index].id);
          //print(items[index].header);

          return CheckListItemFormView(
            item: items[index],
            onChangedHeader: (val) => onChangedHeader(val),
            onChangedSubHeader: (val) => onChangedSubHeader(val),
            onSetLocation: (val) => onSetLocation(val),
            onDelete: (val) {
              onDelete(val!);
            },
            onRemoveLocation: (val) => onRemoveLocation(val!),
            onSetPoints: (val) => onSetPoints(val),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) * 4 / 5,
      color: appBackgroundColor(),
      child: listCauses(),
    );
  }
}
