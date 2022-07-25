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
          fit: BoxFit.cover,
          placeholder: 'assets/images/logo.png',
          image: completeUrl != null && completeUrl != "" && completeUrl != " "
              ? completeUrl!
              : "$driveImageShowUrl${image != null && image != '' ? image : defaultDriveImageShowUrl}",
        ),
      ),
    );
  }
}

class UserImageCus extends StatelessWidget {
  const UserImageCus({
    Key? key,
    this.image,
  }) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: rPrimaryMaterialColorLite,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: NetworkImage(
            "$driveImageShowUrl${image != null && image != "" ? image : defaultUserDriveImageShowUrl}",
          ),
        ),
      ),
    );
  }
}

class BigImageCus extends StatelessWidget {
  const BigImageCus({
    Key? key,
    this.image,
    this.completeUrl,
  }) : super(key: key);

  final String? image;
  final String? completeUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        placeholder: 'assets/images/logo.png',
        image: completeUrl != null && completeUrl != "" && completeUrl != " "
            ? completeUrl!
            : "$driveImageShowUrl${image != null && image != '' ? image : defaultDriveImageShowUrl}",
      ),
    );
  }
}

class UserImageByName extends StatelessWidget {
  const UserImageByName({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: rPrimaryLiteColor,
      child: Text(
        name[0].toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          color: rPrimaryColor,
        ),
      ),
    );
  }
}
