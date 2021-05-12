import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class AddDashbordSite extends StatefulWidget {
  @override
  _AddDashbordSiteState createState() => _AddDashbordSiteState();
}

class _AddDashbordSiteState extends State<AddDashbordSite> {
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
        .then((value) => showSuccessAlert(context, "Url Added Successfully"))
        .catchError((error) => showAlertofError(context, error));
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
    return Scaffold(
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
    );
  }
}
