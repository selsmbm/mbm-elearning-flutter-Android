import 'package:mbm_elearning/Presentation/Constants/constants.dart';

String getDriveImageWithSize(String imageurl, {int? width, int? height}) {
  return "$driveImageShowUrl$imageurl=${width != null && height != null ? "w$width-h$height" : ""}";
}