import 'package:go/app/app.locator.dart';
import 'package:go/enums/bottom_sheet_type.dart';
import 'package:go/ui/bottom_sheets/cause_bottom_sheets/cause_creator_bottom_sheet/cause_creator_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/forum_post_bottom_sheets/forum_post_author_bottom_sheet/forum_post_author_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/forum_post_bottom_sheets/forum_post_publish_successful_bottom_sheet/forum_post_publish_successful_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/image_picker_bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/user_bottom_sheet/current_user_bottom_sheet/current_user_bottom_sheet.dart';
import 'package:go/ui/bottom_sheets/user_bottom_sheet/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

import 'cause_bottom_sheets/cause_bottom_sheet/cause_bottom_sheet.dart';
import 'cause_bottom_sheets/cause_publish_successful_bottom_sheet/cause_publish_successful_bottom_sheet.dart';
import 'forum_post_bottom_sheets/forum_post_bottom_sheet/forum_post_bottom_sheet.dart';

void setupBottomSheetUI() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.imagePicker: (context, sheetRequest, completer) => ImagePickerBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.causePublished: (context, sheetRequest, completer) => CausePublishSuccessfulBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.causeCreatorOptions: (context, sheetRequest, completer) => CauseCreatorBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.causeOptions: (context, sheetRequest, completer) => CauseBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.postPublished: (context, sheetRequest, completer) => ForumPostSuccessfulBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.postAuthorOptions: (context, sheetRequest, completer) => ForumPostAuthorBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.postOptions: (context, sheetRequest, completer) => ForumPostBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.currentUserOptions: (context, sheetRequest, completer) => CurrentUserBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.userOptions: (context, sheetRequest, completer) => UserBottomSheet(request: sheetRequest, completer: completer),
  };
  bottomSheetService.setCustomSheetBuilders(builders);
}
