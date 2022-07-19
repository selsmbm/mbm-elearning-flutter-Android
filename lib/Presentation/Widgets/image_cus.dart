import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';

class ImageCus extends StatelessWidget {
  const ImageCus({
    Key? key,
    this.image,
    this.completeUrl,
  }) : super(key: key);

  final String? image;
  final String? completeUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: rPrimaryLiteColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/logo.png',
          image: completeUrl != null && completeUrl != "" && completeUrl != " "
              ? completeUrl!
              : "$driveImageShowUrl${image != null && image != '' ? image : defaultDriveImageShowUrl}",
        ),
      ),
    );
  }
}
