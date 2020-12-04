import 'package:flutter/material.dart';
import 'package:go/services/dialog_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHandler {
  bool isValidUrl(String url) {
    bool isValid = true;
    var urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    isValid = RegExp(urlPattern, caseSensitive: false).hasMatch(url);
    return isValid;
  }

  launchInWebViewOrVC(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        //forceWebView: true,
        //statusBarBrightness: Brightness.light,
      );
    } else {
      DialogService().showDialog(
        title: "URL Error",
        description: "There was an issue launching this url",
        buttonTitle: "Ok",
      );
    }
  }
}
