import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';

class SignupButton extends StatelessWidget {
  final void Function()? onPressed;
  const SignupButton({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 120,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: rPrimaryColor,
            width: 2,
          ),
          color: const Color(0x66ffffff),
        ),
        child: const Center(
          child: Text(
            "Sign up",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: rPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
