import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  const TextFieldContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: width ?? size.width * 0.8,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor == rPrimaryMaterialColorLite
            ? rPrimaryLiteColor
            : rPrimaryDarkLiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
