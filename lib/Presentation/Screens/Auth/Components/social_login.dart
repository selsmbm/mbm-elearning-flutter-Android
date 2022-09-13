import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
        kIsWeb
            ? const SizedBox()
            : Container(
                width: 260,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (!kIsWeb) {
                      await FirebaseMessaging.instance
                          .subscribeToTopic(mbmEleFcmChannel);
                    }
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var credential = await googleSignIn(context);
                    if (credential != null) {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (prefs.getBool(SP.initialProfileSaved) != null) {
                        Navigator.popAndPushNamed(context, 'dashboard');
                      } else {
                        if (user!.photoURL != null &&
                                user.photoURL!.contains(student) ||
                            user.photoURL!.contains(teacher) ||
                            user.photoURL!.contains(alumni)) {
                          prefs.setBool(SP.initialProfileSaved, true);
                          Navigator.popAndPushNamed(context, 'dashboard');
                        } else {
                          var userd = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          Map? userInitData = userd.data();
                          if (userInitData == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(
                                  isItInitialUpdate: true,
                                ),
                              ),
                            );
                          } else {
                            prefs.setBool(SP.initialProfileSaved, true);
                            await user.updatePhotoURL(userInitData['type']);
                            Navigator.popAndPushNamed(context, 'dashboard');
                          }
                        }
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
                          "Sign in with google",
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
