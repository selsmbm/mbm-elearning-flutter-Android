import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/customPaint.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/mobiledashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../branchesandsems.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class UpdateProfile extends StatefulWidget {
  final userid;
  final userEmail;
  UpdateProfile({this.userid, this.userEmail});
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String branch;
  String mobileNo;
  String year;
  bool showSpiner = false;

  var user = FirebaseFirestore.instance.collection('users');

  Future<void> _addUser(id) {
    return user.doc(id).update({
      'year': year,
      'branch': branch,
      'mobileNo': mobileNo,
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MobileDashbord()),
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
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Update profile', 'Auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "User Profile".text.xl4.bold.color(kFirstColour).make(),
                50.heightBox,
                TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    mobileNo = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Mobile NO.'),
                ).w64(context),
                10.heightBox,
                Container(
                  child: DropdownButtonFormField(
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Select Your Year"),
                    value: year,
                    onChanged: (value) {
                      setState(() {
                        year = value;
                      });
                    },
                    items: years
                        .map((subject) => DropdownMenuItem(
                            value: subject,
                            child: Text("$subject".toUpperCase())))
                        .toList(),
                  ),
                ).centered().w64(context),
                10.heightBox,
                Container(
                  child: DropdownButtonFormField(
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Select Your Branch"),
                    value: branch,
                    onChanged: (value) {
                      setState(() {
                        branch = value;
                      });
                    },
                    items: branches
                        .map((subject) => DropdownMenuItem(
                            value: subject,
                            child: Text("$subject".toUpperCase())))
                        .toList(),
                  ),
                ).centered().w64(context),
                10.heightBox,
                CKGradientButton(
                  onprassed: () async {
                    if (mobileNo.split('').length < 10 ||
                        mobileNo == '0000000000' ||
                        mobileNo == '1234567890') {
                      showAlertofError(context, 'invalid mobile number');
                    } else {
                      if (year == null || mobileNo == null) {
                        showAlertDialog(
                          context,
                        );
                      } else {
                        setState(() {
                          showSpiner = true;
                        });
                        try {
                          _addUser(widget.userid);
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
                    }
                  },
                  buttonText: "submit",
                ),
                10.heightBox,
              ],
            ),
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }
}
