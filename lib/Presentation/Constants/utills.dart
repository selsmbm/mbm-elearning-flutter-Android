import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:share/share.dart';

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
