import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/AuthFunc/Google.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialSigninButton extends StatefulWidget {
  const SocialSigninButton({super.key});

  @override
  State<SocialSigninButton> createState() => _SocialSigninButtonState();
}

class _SocialSigninButtonState extends State<SocialSigninButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox();
    return Container(
      width: 260,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: _loading ? null : _handleGoogleSignIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/google.png'),
                    const SizedBox(width: 5),
                    const Text(
                      "Sign in with google",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      await FirebaseMessaging.instance.subscribeToTopic(mbmEleFcmChannel);
      final prefs = await SharedPreferences.getInstance();
      final credential = await googleSignIn(context);
      if (credential == null) {
        debugPrint('[GoogleSignIn] credential is null — cancelled');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      debugPrint('[GoogleSignIn] user: ${user?.uid}, photoURL: ${user?.photoURL}');

      if (user == null) {
        debugPrint('[GoogleSignIn] currentUser is null after sign-in');
        return;
      }

      if (prefs.getBool(SP.initialProfileSaved) != null) {
        debugPrint('[GoogleSignIn] initialProfileSaved set → dashboard');
        if (mounted) Navigator.pushReplacementNamed(context, 'dashboard');
        return;
      }

      if (user.photoURL != null &&
          (user.photoURL!.contains(student) ||
              user.photoURL!.contains(teacher) ||
              user.photoURL!.contains(alumni))) {
        debugPrint('[GoogleSignIn] photoURL has type → dashboard');
        prefs.setBool(SP.initialProfileSaved, true);
        if (mounted) Navigator.pushReplacementNamed(context, 'dashboard');
        return;
      }

      debugPrint('[GoogleSignIn] fetching Firestore user doc');
      final userd = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userInitData = userd.data();
      debugPrint('[GoogleSignIn] Firestore data: $userInitData');

      if (!mounted) return;
      if (userInitData == null) {
        debugPrint('[GoogleSignIn] no Firestore doc → ProfilePage');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilePage(isItInitialUpdate: true),
          ),
        );
      } else {
        prefs.setBool(SP.initialProfileSaved, true);
        await user.updatePhotoURL(userInitData['type']);
        debugPrint('[GoogleSignIn] updated photoURL → dashboard');
        if (mounted) Navigator.pushReplacementNamed(context, 'dashboard');
      }
    } catch (e, st) {
      debugPrint('[GoogleSignIn] ERROR: $e\n$st');
      if (mounted) setState(() => _loading = false);
    }
  }
}
