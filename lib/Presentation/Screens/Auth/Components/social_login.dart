import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/AuthFunc/Google.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var credential = await googleSignIn(context);
              if (credential != null) {
                if (prefs.getBool(SP.initialProfileSaved) != null) {
                  Navigator.popAndPushNamed(context, 'homePage');
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        isItInitialUpdate: true,
                      ),
                    ),
                  );
                }
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
