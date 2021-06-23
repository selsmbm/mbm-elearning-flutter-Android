import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/customPaint.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/authrepo/signinmobile.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';


class SignupMobile extends StatefulWidget {
  @override
  _SignupMobileState createState() => _SignupMobileState();
}

class _SignupMobileState extends State<SignupMobile> {
  final _auth = FirebaseAuth.instance;
  String userid;
  String email;
  String name;
  String password;

  bool showSpiner = false;

  var user =
      FirebaseFirestore.instance
          .collection('users');

  Future<void> addUser(id) {
    return user.doc(id).set({
      'username': name,
      'useremail': email,
      'year':'null',
      'branch':'null',
      'mobileNo':'null',
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninMobile()),
      );
      setState(() {
        showSpiner = false;
      });
      print("user added");
    }).catchError((error) {
      print('error in adding user');
      setState(() {
        showSpiner = false;
      });
    });
  }

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
            "Already have an account !"
                .text
                .color(Colors.grey)
                .make(),
            10.widthBox,
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SigninMobile()),
                );
              },
              child: "Signin".text.color(kFirstColour).make(),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: SafeArea(
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
                "Signup".text.xl4.bold.color(kFirstColour).make(),
                50.heightBox,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your full name'),
                ).w64(context),
                10.heightBox,
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
                    if (email == null || password == null || name == null) {
                      showAlertDialog(
                        context,
                      );
                    } else {
                      setState(() {
                        showSpiner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          userid = _auth.currentUser.uid;
                          addUser(userid);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          setState(() {
                            showSpiner = false;
                          });
                          showAlertofError(
                            context,
                            "The password provided is too weak.",
                          );
                        } else if (e.code == 'email-already-in-use') {
                          setState(() {
                            showSpiner = false;
                          });
                          showAlertofError(
                            context,
                            "The account already exists for that email.",
                          );
                        }
                      } catch (e) {
                        setState(() {
                          showSpiner = false;
                        });
                        showAlertofError(
                          context,
                          e,
                        );
                        print(e);
                      }
                    }
                  },
                  buttonText: "signup",
                ),
                50.heightBox,
              ],
            ),
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
