import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/progressBar.dart';
import 'package:mbmelearning/Widgets/semTextlistTile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';

class UsefulLinkMb extends StatefulWidget {
  @override
  _UsefulLinkMbState createState() => _UsefulLinkMbState();
}

class _UsefulLinkMbState extends State<UsefulLinkMb> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: Stack(children: [
          HomeWebsites().pLTRB(10, 50, 10, 0),
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
                child: "Useful Links"
                    .text
                    .color(kFirstColour)
                    .bold
                    .xl3
                    .makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}

class HomeWebsites extends StatefulWidget {
  @override
  _HomeWebsitesState createState() => _HomeWebsitesState();
}

class _HomeWebsitesState extends State<HomeWebsites> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.collection('usefulwebsites').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return ProgressBarCus();
        var messages = snapshot.data.docs;
        return ListView(
            children: messages
                .map((doc) => SemText(
                      onPressed: () {
                        setState(() {
                          launch("${doc['weburl']}");
                        });
                      },
                      imgurl: "${doc['imgurl']}",
                      title: "${doc['urltitle']}",
                      desc: "${doc['desc']}",
                    ))
                .toList());
      },
    );
  }
}
