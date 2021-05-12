import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
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
  String mtname;

  String mturl;

  String mtsubject;
  String firstyrsem = 'select sem';

  DropdownButton<String> androidDropdownFirstyr() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String sem in firstyr) {
      var newItem = DropdownMenuItem(
        child: Text(sem).w(context.percentWidth * 60),
        value: sem,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: firstyrsem,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          firstyrsem = value;
          print(firstyrsem);
        });
      },
    );
  }

  String selectedtype = 'select type';

  DropdownButton<String> androidDropdownmtType() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String type in mttypes) {
      var newItem = DropdownMenuItem(
        child: Text(type).w(context.percentWidth * 60),
        value: type,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedtype,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedtype = value;
          print(selectedtype);
        });
      },
    );
  }

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
      showSuccessAlert(context, "material Added Successfully");
    }).catchError((error) => showAlertofError(context, error));
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
    return Scaffold(
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
              onChanged: (value) {
                mtsubject = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Material Subject',
              ),
            ).w64(context),
            10.heightBox,
            androidDropdownmtType(),
            10.heightBox,
            androidDropdownFirstyr(),
            10.heightBox,
            CKOutlineButton(
              onprassed: () {
                if ((mtsubject == null) ||
                    (mtname == null) ||
                    (mturl == null) ||
                    (firstyrsem == 'select sem') ||
                    (selectedtype == 'select type')) {
                  showAlertDialog(context);
                } else {
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
    );
  }
}
