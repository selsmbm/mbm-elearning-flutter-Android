import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'mobile/authrepo/UpdateProfile.dart';
import 'mobile/authrepo/mobilemainScreen.dart';
import 'mobile/authrepo/updateprofileNewUser.dart';
import 'mobile/mobiledashbord.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = FirebaseAuth.instance.currentUser;
  var user = FirebaseFirestore.instance.collection('users');

  checkUser() {
    if (_auth == null) {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MobileMainScreen()));
      });
    } else {
      var userId = _auth.uid;
      var email = _auth.email;
      user.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var mobile = documentSnapshot.data()['mobileNo'];
          if (mobile == 'null') {
            Timer(Duration(seconds: 5), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfile(
                          userid: userId,
                          userEmail: email,
                        )),
              );
            });
          } else {
            Timer(Duration(seconds: 5), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MobileDashbord()),
              );
            });
          }
        } else {
          Timer(Duration(seconds: 5), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateProfileOldUser(
                  userid: userId,
                  userEmail: email,
                ),
              ),
            );
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Center(
                child: Image.asset('assets/mbmlogo.png'),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'MBM E-LEARNING',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFE6963)),
            ),
            Text(
              'from',
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            Text(
              'SELS',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            )
          ],
        ),
      ),
    );
  }
}
