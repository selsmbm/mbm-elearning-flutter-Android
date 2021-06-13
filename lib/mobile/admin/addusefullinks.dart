import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';

class AddDashbordSite extends StatefulWidget {
  @override
  _AddDashbordSiteState createState() => _AddDashbordSiteState();
}

class _AddDashbordSiteState extends State<AddDashbordSite> {
  var textFieldController1 = TextEditingController();
  var textFieldController2 = TextEditingController();
  var textFieldController3 = TextEditingController();
  var textFieldController4 = TextEditingController();
  bool isVisible = false;

  String imgurl;

  String urltitle;

  String discription;

  String weburl;

  CollectionReference websites =
      FirebaseFirestore.instance.collection('usefulwebsites');

  Future<void> addWebsite() {
    return websites
        .add({
          'imgurl': imgurl,
          'urltitle': urltitle,
          'desc': discription,
          'weburl': weburl,
        })
        .then((value) {
      textFieldController1.clear();
      textFieldController2.clear();
      textFieldController3.clear();
      textFieldController4.clear();
      setState(() {
        isVisible = false;
      });
      showSuccessAlert(context, "Url Added Successfully");
    })
        .catchError((error) {
      setState(() {
        isVisible = false;
      });
      showAlertofError(context, error);
    });
  }

  showAlertofError(BuildContext context, String errors) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("😔 Error"),
      content: Text("Failed to add url: $errors"),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isVisible,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: ZStack([
            VStack([
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  60.heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: textFieldController1,
                        onChanged: (value) {
                          urltitle = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Site Name',
                        ),
                      ).w64(context),
                      10.heightBox,
                      TextField(
                        controller: textFieldController2,
                        onChanged: (value) {
                          discription = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                      ).w64(context),
                      10.heightBox,
                      TextField(
                        controller: textFieldController3,
                        onChanged: (value) {
                          imgurl = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Logo url',
                        ),
                      ).w64(context),
                      10.heightBox,
                      TextField(
                        controller: textFieldController4,
                        onChanged: (value) {
                          weburl = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Site url',
                        ),
                      ).w64(context),
                      10.heightBox,
                      CKOutlineButton(
                        onprassed: () {
                          if (imgurl == null ||
                              urltitle == null ||
                              discription == null ||
                              weburl == null) {
                            showAlertDialog(context);
                          } else {
                            setState(() {
                              isVisible = true;
                            });
                            addWebsite();
                          }
                        },
                        buttonText: "Submit",
                      ),
                    ],
                  ).centered(),
                ],
              ),
            ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()).p(20),
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
                  child: "Add New Site"
                      .text
                      .color(kFirstColour)
                      .bold
                      .xl3
                      .makeCentered(),
                ).color(kSecondColour).size(220, 40).make(),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
