import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double? width;
  final Color color;
  final Color textcolor;
  final bool isLoading;
  const SignInButton({
    super.key,
    this.onPressed,
    required this.text,
    this.width,
    this.color = Colors.white,
    this.textcolor = Colors.black,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? 260,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isLoading ? color.withOpacity(0.7) : color,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(textcolor),
                  ),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
