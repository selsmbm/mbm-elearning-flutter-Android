import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

String getDriveImageWithSize(String imageurl, {int? width, int? height}) {
  return "$driveImageShowUrl$imageurl=${width != null && height != null ? "w$width-h$height" : ""}";
}

Future<void> shareDynamicLink({
  required String id,
  required String purpose,
  required String title,
}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: dynamicLinkBaseUrl,
    link: Uri.parse('https://mbmec.weebly.com/?id=$id&purpose=$purpose'),
    androidParameters: AndroidParameters(
      packageName: Flavors.package,
      minimumVersion: 0,
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: title,
      description: "from MBM E-LEARNING",
      imageUrl: Uri.parse("$driveImageShowUrl$defaultDriveImageShowUrl"),
    ),
  );
  final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  Share.share("$title \n${shortLink.shortUrl}");
}

Future<dynamic> bigImageShower(BuildContext context, String imageUrl) async {
  return showDialog(
    context: context,
    builder: (ctx) => InteractiveViewer(
      child: !imageUrl.contains("http")
          ? Image.memory(base64Decode(imageUrl.split(',').last))
          : Image.network(
              imageUrl,
            ),
    ),
  );
}

targetFocus(String text, IconData icon, GlobalKey key, String identify,
    {bool isTop = true}) {
  return TargetFocus(
    identify: identify,
    keyTarget: key,
    alignSkip: Alignment.topRight,
    contents: [
      TargetContent(
        align: isTop ? ContentAlign.top : ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.tealAccent,
                size: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}
