import 'package:flutter/services.dart';
import 'package:go/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

copyShareableLink({String? link}) async {
  DialogService dialogService = locator<DialogService>();
  Clipboard.setData(ClipboardData(text: link));
  HapticFeedback.lightImpact();
  dialogService.showDialog(
    title: "Link Copied!",
    description: "",
    barrierDismissible: true,
    buttonTitle: "Ok",
  );
}
