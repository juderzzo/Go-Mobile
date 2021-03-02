import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/check_list_item/check_list_item_form/check_list_item_form_view.dart';

// class ListCheckListItems extends StatelessWidget {
//   final List<GoCheckListItem> items;
//   final VoidCallback refreshData;
//   final PageStorageKey pageStorageKey;
//   final ScrollController scrollController;
//
//   ListCheckListItems(
//       {@required this.refreshData,
//         @required this.items,
//         @required this.pageStorageKey,
//         @required this.scrollController,});
//
//   Widget listCauses() {
//     return RefreshIndicator(
//       onRefresh: refreshData,
//       backgroundColor: appBackgroundColor(),
//       child: ListView.builder(
//         physics: AlwaysScrollableScrollPhysics(),
//         controller: scrollController,
//         key: pageStorageKey,
//         addAutomaticKeepAlives: true,
//         shrinkWrap: true,
//         padding: EdgeInsets.only(
//           top: 4.0,
//           bottom: 4.0,
//         ),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           GoCause cause;
//           bool displayBottomBorder = true;
//
//           ///GET CAUSE OBJECT
//           if (causesResults[index] is DocumentSnapshot) {
//             cause = GoCause.fromMap(causesResults[index].data());
//           } else {
//             cause = causesResults[index];
//           }
//
//           ///DISPLAY BOTTOM BORDER
//           if (causesResults.last == causesResults[index]) {
//             displayBottomBorder = false;
//           }
//
//           if(cause.approved){
//             return CauseBlockView(
//               cause: cause,
//               displayBottomBorder: displayBottomBorder,
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: screenHeight(context),
//       color: appBackgroundColor(),
//       child: listCauses(),
//     );
//   }
// }

class ListCheckListItemsForEditing extends StatelessWidget {
  final List<GoCheckListItem> items;
  final VoidCallback refreshData;
  final PageStorageKey pageStorageKey;
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onChangedHeader;
  final Function(Map<String, dynamic>) onChangedSubHeader;
  final Function(Map<String, dynamic>) onSetLocation;
  final Function(String) onDelete;
  final Function(String) onRemoveLocation;

  ListCheckListItemsForEditing({
    @required this.refreshData,
    @required this.items,
    @required this.pageStorageKey,
    @required this.scrollController,
    @required this.onChangedHeader,
    @required this.onChangedSubHeader,
    @required this.onSetLocation,
    @required this.onDelete,
    @required this.onRemoveLocation,
  });

  Widget listCauses() {
    return RefreshIndicator(
      onRefresh: refreshData,
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
          return CheckListItemFormView(
            item: items[index],
            onChangedHeader: (val) => onChangedHeader(val),
            onChangedSubHeader: (val) => onChangedSubHeader(val),
            onSetLocation: (val) => onSetLocation(val),
            onDelete: (val) => onDelete(val),
            onRemoveLocation: (val) => onRemoveLocation(val),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context),
      color: appBackgroundColor(),
      child: listCauses(),
    );
  }
}
