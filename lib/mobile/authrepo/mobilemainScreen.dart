import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbmelearning/mobile/mobiledashbord.dart';
import 'package:mbmelearning/mobile/authrepo/signinmobile.dart';
import 'package:mbmelearning/mobile/authrepo/signupmobile.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/constants.dart';

//Todo:google signin.
class MobileMainScreen extends StatefulWidget {
  MobileMainScreen({
    Key key,
  }) : super(key: key);

  @override
  _MobileMainScreenState createState() => _MobileMainScreenState();
}

class _MobileMainScreenState extends State<MobileMainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String name_google;
  String email_google;
  String imageUrl_google;
  String uid;

  Future<String> signInWithGoogle() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User user = userCredential.user;

    if (user != null) {
      // Checking if email and name is null
      assert(user.uid != null);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      uid = user.uid;
      name_google = user.displayName;
      email_google = user.email;
      imageUrl_google = user.photoURL;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('auth', true);

      return 'Google sign in successful, User UID: ${user.uid}';
    }

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onprassed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninMobile()),
                );
              },
            ),
            30.widthBox,
            CKOutlineButton(
              buttonText: "Signup",
              onprassed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupMobile()),
                );
              },
            ),
          ]).centered(),
          20.heightBox,
          // "or".text.color(kFirstColour).makeCentered(),
          // 20.heightBox,
          // Center(
          //   child: FlatButton(
          //     onPressed: () async {
          //       await signInWithGoogle().then((result) {
          //         print(result);
          //         Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(
          //             fullscreenDialog: true,
          //             builder: (context) => MobileDashbord(),
          //           ),
          //         );
          //       }).catchError((error) {
          //         print('Registration Error: $error');
          //       });
          //     },
          //     child: Container(
          //       height: 45,
          //       width: 200,
          //       child: Image.asset(
          //           'assets/googlesignin.png'
          //       ),
          //     ),
          //   ),
          // ),
          20.heightBox,
        ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}

