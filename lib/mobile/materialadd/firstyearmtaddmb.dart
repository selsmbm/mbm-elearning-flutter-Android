import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

import '../../branchesandsems.dart';

class FirstyearMaterialMobileAdd extends StatefulWidget {
  final approve;
  FirstyearMaterialMobileAdd({this.approve});
  @override
  _FirstyearMaterialMobileAddState createState() =>
      _FirstyearMaterialMobileAddState();
}

class _FirstyearMaterialMobileAddState
    extends State<FirstyearMaterialMobileAdd> {
  var textFieldController1 = TextEditingController();
  var textFieldController2 = TextEditingController();
  var textFieldController3 = TextEditingController();

  bool isVisible = false;
  String mtname;
  String mturl;
  String mtsubject;
  String firstyrsem;
  String selectedtype;


  CollectionReference mt = FirebaseFirestore.instance.collection('firstyearmt');

  Future<void> addMaterial() {
    return mt.add({
      'mtname': mtname,
      'mturl': mturl,
      'mtsubject': mtsubject,
      'mtsem': firstyrsem,
      'mttype': selectedtype,
      'approve': widget.approve,
    }).then((value) {
      setState(() {
        isVisible = false;
      });
      textFieldController1.clear();
      textFieldController2.clear();
      textFieldController3.clear();
      showSuccessAlert(context, "material Added Successfully");
    }).catchError((error) {
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
      content: Text("Failed to add metarial: $errors"),
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
              40.heightBox,
              Text(
                "Only First Year Material Add Hare",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              10.heightBox,
              TextField(
                controller: textFieldController1,
                onChanged: (value) {
                  mtname = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Material Name',
                ),
              ).w64(context),
              10.heightBox,
              TextField(
                controller: textFieldController2,
                onChanged: (value) {
                  mturl = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Material URL',
                ),
              ).w64(context),
              10.heightBox,
              TextField(
                controller: textFieldController3,
                onChanged: (value) {
                  mtsubject = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Material Subject',
                ),
              ).w64(context),
              10.heightBox,
              Container(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Select Type",
                  ),
                  value: selectedtype,
                  onChanged: (value) {
                    setState(() {
                      selectedtype = value;
                    });
                  },
                  items: mttypes
                      .map((subject) => DropdownMenuItem(
                      value: subject, child: Text("$subject".toUpperCase())))
                      .toList(),
                ),
              ).centered().w64(context),
              10.heightBox,
              Container(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Select Sem",
                  ),
                  value: firstyrsem,
                  onChanged: (value) {
                    setState(() {
                      firstyrsem = value;
                    });
                  },
                  items: firstyr
                      .map((subject) => DropdownMenuItem(
                      value: subject, child: Text("$subject".toUpperCase())))
                      .toList(),
                ),
              ).centered().w64(context),
              10.heightBox,
              CKOutlineButton(
                onprassed: () {
                  if ((mtsubject == null) ||
                      (mtname == null) ||
                      (mturl == null) ||
                      (firstyrsem == null) ||
                      (selectedtype == null)) {
                    showAlertDialog(context);
                  } else {
                    setState(() {
                      isVisible = true;
                    });
                    addMaterial();
                  }
                },
                buttonText: "Submit",
              ),
              20.heightBox,
            ])
                .scrollVertical(physics: AlwaysScrollableScrollPhysics())
                .p(20)
                .centered(),
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
                  child: "Add New Material"
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
