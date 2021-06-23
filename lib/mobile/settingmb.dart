import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:mbmelearning/mobile/staticPages/contactmobile.dart';
import 'package:mbmelearning/mobile/authrepo/mobilemainScreen.dart';
import 'package:mbmelearning/mobile/staticPages/tncmb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';

final _auth = FirebaseAuth.instance;
String email = _auth.currentUser.email;
String uid = _auth.currentUser.uid;
String newPassword;
String confirmPassword;

class SettingMB extends StatefulWidget {
  @override
  _SettingMBState createState() => _SettingMBState();
}

class _SettingMBState extends State<SettingMB> {

  void _changePassword(String newpassword) async {
    _auth.currentUser.updatePassword(newpassword).then((_) {
      showSuccessAlert(context, "Successfully changed password");
    }).catchError((error) {
      showAlertofError(context, "Password can't be changed" + error.toString());
    });
  }

  void _deleteAccount() async{
    _auth.currentUser.delete().then((value) {
      showSuccessAlert(context, "Successfully Delete your Account");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MobileMainScreen()));
    }).onError((error, stackTrace) => showAlertofError(context,error));
  }

  Future<void> _confirmDelete(BuildContext context) async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("delete"),
      onPressed:  () {
        _deleteAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("⚠ Worning"),
      content: Text("Are you sure that you want to delete your account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  final newPassController = TextEditingController();
  final confPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            VStack([
              "Email : $email".text.make(),
              10.widthBox,
              "UserId : $uid".text.make(),
            ]).p(10),
            20.heightBox,
            HStack([
              TextButton(
                onPressed: () {
                  setState(() {
                    _auth.signOut();
                    SystemNavigator.pop();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF4FD1C5),
                  ),
                  height: context.percentHeight * 20,
                  width: context.percentWidth * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Logout".text.xl2.white.makeCentered()
                    ],
                  ),
                ),
              ),
              20.widthBox,
              TextButton(
                onPressed: () {
                  setState(() {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('share')
                          .doc('cG2SEGWyCocbHDLdqJLX')
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          launch(
                              'https://www.addtoany.com/share#url=${documentSnapshot.data()['link']}&title=${documentSnapshot.data()['massage']}');
                          print('Document data: ${documentSnapshot.data()}');
                        } else {
                          launch('https://mbmec.weebly.com/mbm-apk.html');
                        }
                      });
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF68D391),
                  ),
                  height: context.percentHeight * 20,
                  width: context.percentWidth * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Share".text.xl2.white.makeCentered()
                    ],
                  ),
                ),
              ),
            ])
                .scrollHorizontal(physics: AlwaysScrollableScrollPhysics())
                .centered(),
            10.heightBox,
            HStack([
              TextButton(
                onPressed: () {
                  setState(() {
                    launch('mailto:lkrjangid@gmail.com');
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF63B3ED),
                  ),
                  height: context.percentHeight * 20,
                  width: context.percentWidth * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bug_report_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Bug Report".text.xl2.white.makeCentered()
                    ],
                  ),
                ),
              ),
              20.widthBox,
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactMobile()),
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF7F9CF5),
                  ),
                  height: context.percentHeight * 20,
                  width: context.percentWidth * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "Contact".text.xl2.white.makeCentered()
                    ],
                  ),
                ),
              ),
            ])
                .scrollHorizontal(physics: AlwaysScrollableScrollPhysics())
                .centered(),
            10.heightBox,
            HStack([
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TNCmb()),
                    );
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFB794F4),
                  ),
                  height: context.percentHeight * 20,
                  width: context.percentWidth * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.text_snippet_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                      10.heightBox,
                      "T & C".text.xl2.white.makeCentered()
                    ],
                  ),
                ),
              ),
            ])
                .scrollHorizontal(physics: AlwaysScrollableScrollPhysics())
                .centered(),
            20.heightBox,
            "Change Password".text.xl2.color(kFirstColour).make().centered(),
            VxBox().color(kFirstColour).size(60, 2).make().centered(),
            10.heightBox,
            TextField(
              onChanged: (v) {
                newPassword = v;
              },
              controller: newPassController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
              ),
            ).w64(context).centered(),
            10.heightBox,
            TextField(
              onChanged: (v) {
                confirmPassword = v;
              },
              controller: confPassController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ).w64(context).centered(),
            10.heightBox,
            CKOutlineButton(
              onprassed: () {
                if (newPassword == null ||
                    confirmPassword == null ||
                    newPassword == '' ||
                    confirmPassword == '') {
                  showAlertDialog(context);
                } else{
                  if (newPassword == confirmPassword) {
                    confPassController.clear();
                    newPassController.clear();
                    _changePassword(newPassword);
                  } else {
                    showAlertofError(context,
                        'your new password and confirm password does not match please retry');
                  }
                }
              },
              buttonText: "Submit",
            ).centered(),
            // 20.heightBox,
            // "Delete Account".text.xl2.color(kFirstColour).make().centered(),
            // VxBox().color(kFirstColour).size(60, 2).make().centered(),
            // 10.heightBox,
            // CKOutlineButton(
            //   onprassed: (){
            //     _confirmDelete(context);
            //   },
            //   buttonText: "Delete",
            // ).centered(),
            20.heightBox,
            BottomBar(),
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()).p(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: VxBox(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50, 40).make(),
              ),
              VxBox(
                child:
                    "Setting".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
