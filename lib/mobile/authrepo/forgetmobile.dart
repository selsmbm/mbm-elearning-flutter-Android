import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/customPaint.dart';
import 'package:mbmelearning/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:ui' as ui;

class ForgetMobile extends StatefulWidget {
  @override
  _ForgetMobileState createState() => _ForgetMobileState();
}

class _ForgetMobileState extends State<ForgetMobile> {
  final _auth = FirebaseAuth.instance;

  String email;
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
            "Back to".text.color(Colors.grey).make(),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: "Signin".text.color(kFirstColour).make(),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: SafeArea(child: VStack([
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                child: CustomPaint(
                  painter: RPSCustomPainter(
                  ),
                ),
              ),
              "Forgot Password".text.xl4.bold.color(kFirstColour).make(),
              50.heightBox,
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ).w64(context),
              10.heightBox,
              CKGradientButton(
                onprassed: () async{
                 if(email == null){
                   showAlertDialog(context);
                 } else{
                   setState(() {
                     showSpiner = true;
                   });
                   try{
                     await _auth.sendPasswordResetEmail(email: email);
                     setState(() {
                       showSpiner = false;
                       showSuccessAlert(context,"Password Reset email send successfully");
                     });
                   }
                   catch (e){
                     showAlertofError(context, e);
                     print(e);
                   }
                 }
                },
                buttonText: "submit",
              ),
            ],
          ),
        ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),),
      ),
    );
  }
}

