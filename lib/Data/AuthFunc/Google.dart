import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> googleSignIn(context) async {
  await Firebase.initializeApp();
  final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please wait'),
      ),
    );
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    assert(!user!.isAnonymous);
    final User? currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    return currentUser!;
  }
  return null;
}
