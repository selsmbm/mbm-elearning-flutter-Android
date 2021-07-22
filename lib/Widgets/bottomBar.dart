import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants.dart';
import '../mobile/admin/admindashbordmb.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VStack([
        TextButton(onPressed: (){
          setState(() {
            FirebaseFirestore.instance
                .collection('adminids')
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                print(doc["id"]);
                print(userId);
                if(doc["id"] == userId){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminMobileDashbord()),
                  );
                }
              });
            });
          });
        }, child: "MBM E-LEARNING".text.color(kFirstColour).xl2.bold.make().centered(),),
        "Made by SELS".text.makeCentered(),
        "Version : ^4.0.0".text.makeCentered(),
        IconButton(
          icon: Icon(AntDesign.linkedin_square,color: kFirstColour,),
          tooltip: 'SELS Linkedin',
          onPressed: () {
            setState(() {
              launch('https://www.linkedin.com/company/society-of-e-learning-students');
            });
          },
        ).centered(),
        VxBox().color(kFirstColour).size(60, 2).makeCentered(),
        "Copyright © All rights reserved"
            .text
            .gray500
            .makeCentered(),
        50.heightBox,
      ]),
    );
  }
}
