import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/customPaint.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/authrepo/UpdateProfile.dart';
import 'package:mbmelearning/mobile/authrepo/forgetmobile.dart';
import 'package:mbmelearning/mobile/authrepo/updateprofileNewUser.dart';
import 'package:mbmelearning/mobile/mobiledashbord.dart';
import 'package:mbmelearning/mobile/authrepo/signupmobile.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';


class SigninMobile extends StatefulWidget {
  @override
  _SigninMobileState createState() => _SigninMobileState();
}

class _SigninMobileState extends State<SigninMobile> {
  final _auth = FirebaseAuth.instance;
  var user = FirebaseFirestore.instance.collection('users');
  String userId;
  String email;

  String password;

  bool showSpiner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: kFirstColour,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Don't have an account !".text.color(Colors.grey).make(),
            10.widthBox,
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupMobile()),
                );
              },
              child: "Signup".text.color(kFirstColour).make(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpiner,
          child: VStack([
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: RPSCustomPainter(),
                  ),
                ),
                "Signin".text.xl4.bold.color(kFirstColour).make(),
                50.heightBox,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ).w64(context),
                10.heightBox,
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ).w64(context),
                10.heightBox,
                CKGradientButton(
                  onprassed: () async {
                    if (email == null || password == null) {
                      showAlertDialog(context);
                    } else {
                      setState(() {
                        showSpiner = true;
                      });
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (newUser != null) {
                          userId = _auth.currentUser.uid;
                          user.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
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
                                    MaterialPageRoute(builder: (context) => MobileDashbord()),
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
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          setState(() {
                            showSpiner = false;
                          });
                          print('No user found for that email.');
                          showAlertofError(context,
                              'No user found for that email.',);
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            showSpiner = false;
                          });
                          print('Wrong password provided for that user.');
                          showAlertofError(
                              context,
                              'Wrong password provided for that user.',
                              );
                        }
                      } catch (e) {
                        setState(() {
                          showSpiner = false;
                        });
                        showAlertofError(context, e, );
                        print(e);
                      }
                    }
                  },
                  buttonText: "signin",
                ),
                20.heightBox,
                "or".text.color(kFirstColour).make(),
                20.heightBox,
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetMobile()),
                    );
                  },
                  child: "Forgot Password?".text.color(Colors.grey).make(),
                ),
                20.heightBox,
              ],
            ),
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
