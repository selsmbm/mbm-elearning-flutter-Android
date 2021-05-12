import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

import '../../branchesandsems.dart';

class SecondtoFinaladdmtmb extends StatefulWidget {
  final approve;
  SecondtoFinaladdmtmb({this.approve});
  @override
  _SecondtoFinaladdmtmbState createState() => _SecondtoFinaladdmtmbState();
}

class _SecondtoFinaladdmtmbState extends State<SecondtoFinaladdmtmb> {
  String mtname;
  String mturl;
  String mtsubject;
  String selectedSems = 'select sem';
  String selectedBranch = 'select branch';
  String selectedtype = 'select type';
  DropdownButton<String> androidDropdownSems() {
    List<DropdownMenuItem<String>> dropdownItemssem = [];
    for (String sem in sems) {
      var newItemsem = DropdownMenuItem(
        child: Text(sem).w(context.percentWidth * 60),
        value: sem,
      );
      dropdownItemssem.add(newItemsem);
    }

    return DropdownButton<String>(
      value: selectedSems,
      items: dropdownItemssem,
      onChanged: (value) {
        setState(() {
          selectedSems = value;
          print(selectedSems);
        });
      },
    );
  }

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
      value: selectedBranch,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedBranch = value;
          print(selectedBranch);
        });
      },
    );
  }

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

  CollectionReference mt =
      FirebaseFirestore.instance.collection('secondtofinalyearmt');

  Future<void> addMaterial() {
    return mt.add({
      'mtname': mtname,
      'mturl': mturl,
      'mtsubject': mtsubject,
      'mtbranch': selectedBranch,
      'mtsem': selectedSems,
      'mttype': selectedtype,
      'approve': widget.approve,
    }).then((value) {
      showSuccessAlert(context,"material Added Successfully");
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
            60.heightBox,
            Text(
              "Only Second to Final Year Material Add Hare",
              style: TextStyle(
                fontSize: 13,
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
            androidDropdownBranches(),
            10.heightBox,
            androidDropdownSems(),
            10.heightBox,
            CKOutlineButton(
              onprassed: () {
                if ((mtsubject == null) ||
                    (mtname == null) ||
                    (mturl == null) ||
                    (selectedSems == 'select sem') ||
                    (selectedtype == 'select type') ||
                    (selectedBranch == 'select branch')) {
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
