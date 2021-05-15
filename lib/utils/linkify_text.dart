import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/utils/url_handler.dart';

final String urlPattern = r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";
const String emailPattern = r'\S+@\S+';
const String phonePattern = r'[\d-]{9,}';
final RegExp linkRegExp = RegExp('($urlPattern)|($emailPattern)|($phonePattern)', caseSensitive: false);

List<TextSpan> linkify({required String text, double? fontSize}) {
  String modifiedText = text.replaceAll("\n", "!***NEWLINE***!");
  var linkMatches = linkRegExp.allMatches(modifiedText);

  List<TextSpan> linkedTextSpans = [];
  int lastIndex = 0;
  if (linkMatches.isEmpty) {
    return [
      TextSpan(
        text: text,
        style: TextStyle(
          color: appFontColor(),
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
      )
    ];
  }
  linkMatches.forEach((match) {
    TextSpan linkFreeText = TextSpan(
      text: modifiedText.substring(lastIndex, match.start).replaceAll("!***NEWLINE***!", "\n"),
      style: TextStyle(
        color: appFontColor(),
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
    TextSpan linkTextSpan = TextSpan(
      text: modifiedText.substring(match.start, match.end),
      style: TextStyle(
        color: appTextButtonColor(),
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          UrlHandler().launchInWebViewOrVC(modifiedText.substring(match.start, match.end));
        },
    );
    linkedTextSpans.add(linkFreeText);
    linkedTextSpans.add(linkTextSpan);
    lastIndex = match.end;
  });
  return linkedTextSpans;
}
