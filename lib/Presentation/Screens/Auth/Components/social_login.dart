import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/AuthFunc/Google.dart';

class SocialSigninButton extends StatelessWidget {
  const SocialSigninButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 260,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: TextButton(
            onPressed: () async {
              var credential = await googleSignIn(context);
              if (credential != null) {
                Navigator.pushNamed(context, 'homePage');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/google.png'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Sigin in with google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
