import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:stacked/stacked.dart';

class GoChecklistItem {
  String id;
  CauseCheckListItem item;

  GoChecklistItem({this.id, this.item});

  GoChecklistItem.fromMap(Map<String, dynamic> data)
      : this(
            id: data['id'],
            item: CauseCheckListItem(
                isChecked: false,
                header: data['header'],
                subHeader: data['subheader'],
      ));

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'action': this.item.header,
        'subheader': this.item.subHeader
      };



}
