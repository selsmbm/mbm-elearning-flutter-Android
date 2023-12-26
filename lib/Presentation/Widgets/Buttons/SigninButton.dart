import 'package:flutter/material.dart';


class SignInButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double? width;
  final Color color;
  final Color textcolor;
  const SignInButton(
      {super.key, this.onPressed,
      required this.text,
      this.width,
      this.color = Colors.white,
      this.textcolor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 260,
        height: 44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: color),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),),
        ),
      ),
    );
  }
}
