import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/customPaint.dart';
import 'package:mbmelearning/constants.dart';
import 'package:mbmelearning/mobile/authrepo/signinmobile.dart';
import 'package:mbmelearning/mobile/mobiledashbord.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../branchesandsems.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kFirstColour, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

class UpdateProfileOldUser extends StatefulWidget {
  final userid;
  final userEmail;
  UpdateProfileOldUser({this.userid,this.userEmail});
  @override
  _UpdateProfileOldUserState createState() => _UpdateProfileOldUserState();
}

class _UpdateProfileOldUserState extends State<UpdateProfileOldUser> {
  String branch = 'select branch';
  String name;
  String mobileNo;
  String year;
  bool showSpiner = false;

  DropdownButton<String> androidDropdownBranches() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String branch in branches) {
      var newItem = DropdownMenuItem(
        child: Text(branch).w(context.percentWidth * 60),
        value: branch,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: branch,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          branch = value;
          print(branch);
        });
      },
    );
  }

  var user = FirebaseFirestore.instance.collection('users');

  Future<void> _addUser(id) {
    return user.doc(id).set({
      'username': name,
      'useremail': widget.userEmail,
      'year': year,
      'branch': branch,
      'mobileNo':mobileNo,
    }).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MobileDashbord()),
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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Name'),
                ).w64(context),
                10.heightBox,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    mobileNo = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Mobile NO.'),
                ).w64(context),
                10.heightBox,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    year = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Year'),
                ).w64(context),
                10.heightBox,
                androidDropdownBranches(),
                10.heightBox,
                CKGradientButton(
                  onprassed: () async {
                    if (year == null || mobileNo == null || name == null) {
                      showAlertDialog(context,);
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
                        showAlertofError(context, e,);
                        print(e);
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
