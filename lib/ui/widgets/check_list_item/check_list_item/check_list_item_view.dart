import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_check_list_item.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart';
import 'package:stacked/stacked.dart';

class CheckListItemView extends StatelessWidget {
  final bool? isChecked;
  final GoCheckListItem item;
  final Function(GoCheckListItem) checkOffItem;

  CheckListItemView({
    required this.isChecked,
    required this.item,
    required this.checkOffItem,
  });

  Widget checker(BuildContext context) {
    return GestureDetector(
      onTap: () => checkOffItem(item),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: item.lon == null
            ? BoxDecoration(
                color: appBackgroundColor(),
                border: Border.all(width: 1.0, color: appBorderColorAlt()),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: appShadowColor(),
                    spreadRadius: 0.3,
                    blurRadius: 1.5,
                    offset: Offset(0.0, 1.5),
                  ),
                ],
              )
            : null,
        child: Row(
          children: [
            isChecked!
                ? Checkbox(
                    activeColor: CustomColors.goGreen,
                    onChanged: (bol) {
                      if(!isChecked!){
                        checkOffItem(item);
                      }
                      
                    },
                    value: isChecked,
                  )
                : SizedBox(
                    width: 43, child: Icon(Icons.check_box_outline_blank)),
            item.address == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Text(
                        item.header!,
                        style: TextStyle(
                          fontSize: 22,
                          color: appFontColor(),
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      //SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width * 11 / 16,
                        child: Text(
                          item.subHeader!,
                          style: TextStyle(
                            fontSize: 14,
                            color: appFontColor(),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        item.header!,
                        style: TextStyle(
                          fontSize: 16,
                          color: appFontColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 9 / 16,
                        child: Text(
                          item.subHeader!,
                          style: TextStyle(
                            fontSize: 14,
                            color: appFontColor(),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
            Text(
              item.points.toString(),
              style: TextStyle(color: CustomColors.goGreen, fontSize: 20),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListViewModel>.reactive(
        viewModelBuilder: () => CheckListViewModel(),
        builder: (context, model, child) => item.lat == null
            ? checker(context)
            : Container(
              decoration: BoxDecoration(
                          color: appBackgroundColor(),
                          border: Border.all(
                              width: 1.0, color: appBorderColorAlt()),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: appShadowColor(),
                              spreadRadius: 0.3,
                              blurRadius: 1.5,
                              offset: Offset(0.0, 1.5),
                            ),
                          ],
                        ),
                child: Column(
                  children: [
                    Container(
                        
                        height: MediaQuery.of(context).size.height * 1 / 5,
                        width: MediaQuery.of(context).size.height * 3 / 4,
                        child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(item.lat!, item.lon!), zoom: 12))),
                        SizedBox(height: 10,),
                        Text(
                        item.address!,
                        style: TextStyle(
                          fontSize: 12,
                          color: appFontColorAlt(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                    checker(context)
                  ],
                ),
              ));
  }
}
