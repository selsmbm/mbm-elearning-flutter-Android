import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/authrepo/signinmobile.dart';
import 'package:mbmelearning/mobile/authrepo/signupmobile.dart';
import 'package:mbmelearning/mobile/authrepo/updateprofileNewUser.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';

import '../mobiledashboard.dart';
import 'UpdateProfile.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class MobileMainScreen extends StatefulWidget {
  MobileMainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MobileMainScreenState createState() => _MobileMainScreenState();
}

class _MobileMainScreenState extends State<MobileMainScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = FirebaseFirestore.instance.collection('users');
  bool showSpiner = false;

  Future googleSignIn() async {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    print(currentUser.uid);
    return currentUser;
  }

  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('MainScreen', 'Auth');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpiner,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: VStack([
            30.heightBox,
            "MBM E-Learning".text.color(kFirstColour).bold.xl3.makeCentered(),
            10.heightBox,
            Center(
              child: Image.asset(
                'assets/mainscreen.png',
                height: 300,
                width: 300,
              ),
            ),
            20.heightBox,
            HStack([
              CKGradientButton(
                buttonText: "Signin",
                onprassed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninMobile()),
                  );
                },
              ),
              30.widthBox,
              CKOutlineButton(
                buttonText: "Signup",
                onprassed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupMobile()),
                  );
                },
              ),
            ]).centered(),
            20.heightBox,
            "or".text.color(kFirstColour).makeCentered(),
            20.heightBox,
            Center(
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    showSpiner = true;
                  });
                  await googleSignIn().then((result) {
                    if (_auth.currentUser != null) {
                      var userId = _auth.currentUser.uid;
                      var email = _auth.currentUser.email;
                      user
                          .doc(userId)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          var mobile = documentSnapshot.data()['mobileNo'];
                          if (mobile == 'null') {
                            setState(() {
                              showSpiner = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfile(
                                        userid: userId,
                                        userEmail: email,
                                      )),
                            );
                          } else {
                            setState(() {
                              showSpiner = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MobileDashbord()),
                            );
                          }
                        } else {
                          setState(() {
                            showSpiner = false;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfileOldUser(
                                userid: userId,
                                userEmail: email,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  }).catchError((error) {
                    print('Registration Error: $error');
                  });
                },
                child: Container(
                  height: 50,
                  width: 250,
                  child: Image.asset('assets/googlesignin.png'),
                ),
              ),
            ),
            20.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
