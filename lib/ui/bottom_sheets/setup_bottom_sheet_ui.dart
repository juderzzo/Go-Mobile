import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/ui/bottom_sheets/cause_publish_successful_bottom_sheet/cause_publish_successful_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/image_picker_bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

void setupBottomSheetUI() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) => _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.imagePicker: (context, sheetRequest, completer) => ImagePickerBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.causePublished: (context, sheetRequest, completer) => CausePublishSuccessfulBottomSheet(request: sheetRequest, completer: completer),
  };
  bottomSheetService.setCustomSheetBuilders(builders);
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const _FloatingBoxBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: appBackgroundColor(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ),
          SizedBox(height: 10),
          Text(
            request.description,
            style: TextStyle(
              color: appFontColorAlt(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                child: Text(
                  request.secondaryButtonTitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              FlatButton(
                onPressed: () => completer(SheetResponse(confirmed: true)),
                child: Text(
                  request.mainButtonTitle,
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              )
            ],
          )
        ],
      ),
    );
  }
}
