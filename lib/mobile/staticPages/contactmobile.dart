import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mbmelearning/Analytics.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:mbmelearning/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

AnalyticsClass _analyticsClass = AnalyticsClass();

class ContactMobile extends StatefulWidget {
  @override
  _ContactMobileState createState() => _ContactMobileState();
}

class _ContactMobileState extends State<ContactMobile> {
  String userName;
  String userEmail;
  String userMassage;
  CollectionReference massage =
      FirebaseFirestore.instance.collection('contactMassage');

  Future<void> contactMassageAdd() {
    return massage.add({
      'userName': userName,
      'userEmail': userEmail,
      'userMassage': userMassage,
    }).then((value) {
      showSuccessAlert(context, false);
    }).catchError((error) => showAlertofError(context, error));
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final massageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _analyticsClass.setCurrentScreen('Contact us', 'Home');
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/dev%2F1604127426346.jpg?alt=media&token=2153ac7b-97ff-4929-b63e-49a33d21ff98'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Dr. Kailash Chaudhary".text.xl2.make(),
                    "Assistant Professor".text.gray500.make(),
                    "k.chaudhary.mech@jnvu.edu.in"
                        .text
                        .gray500
                        .make()
                        .onTap(() {
                      launch('mailto:k.chaudhary.mech@jnvu.edu.in');
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            launch(
                                'https://www.linkedin.com/in/dr-kailash-chaudhary-5b36bb12/');
                          },
                          icon: Icon(
                            AntDesign.linkedin_square,
                            color: Colors.blue,
                          ),
                        ).centered(),
                        IconButton(
                          onPressed: () {
                            launch(
                                'https://sites.google.com/jnvu.edu.in/drkailashchaudhary/home');
                          },
                          icon: Icon(
                            AntDesign.link,
                            color: Colors.blue,
                          ),
                        ).centered(),
                      ],
                    ).w(double.infinity),
                  ],
                ),
                20.heightBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/lokesh.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Lokesh Jangid".text.xl2.make(),
                    "Electrical Engineering".text.gray500.make(),
                    "lkrjangid@gmail.com".text.gray500.make().onTap(() {
                      launch('mailto:lkrjangid@gmail.com');
                    }),
                    IconButton(
                      onPressed: () {
                        launch('https://www.linkedin.com/in/lkrjangid/');
                      },
                      icon: Icon(
                        AntDesign.linkedin_square,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                20.heightBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/dev%2F1625904826562.jpg?alt=media&token=2321ea10-4298-493b-b15b-296f87ce23b2'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Kapil Gupta".text.xl2.make(),
                    "Civil Engineering".text.gray500.make(),
                    "guptakapil24000@gmail.com".text.gray500.make().onTap(() {
                      launch('mailto:guptakapil24000@gmail.com');
                    }),
                    IconButton(
                      onPressed: () {
                        launch(
                            'https://www.linkedin.com/in/kapil-gupta-b991b511b/');
                      },
                      icon: Icon(
                        AntDesign.linkedin_square,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                20.heightBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/mbmecj.appspot.com/o/dev%2F1623041275486.jpg?alt=media&token=20d5d246-8cbc-4a64-9098-5a58e0f6d6cf'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Kashish Agarawal".text.xl2.make(),
                    "Civil Engineering".text.gray500.make(),
                    "kashishagrawal0005@gmail.com"
                        .text
                        .gray500
                        .make()
                        .onTap(() {
                      launch('mailto:kashishagrawal0005@gmail.com');
                    }),
                    IconButton(
                      onPressed: () {
                        launch(
                            'https://www.linkedin.com/in/kashish-agrawal-a814161aa/');
                      },
                      icon: Icon(
                        AntDesign.linkedin_square,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                30.heightBox,
                Image.asset(
                  'assets/contact.png',
                ),
                30.heightBox,
                "Contact Form".text.xl4.color(kFirstColour).make(),
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      onChanged: (v) {
                        userName = v;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full Name',
                      ),
                    ).w64(context),
                    10.heightBox,
                    TextField(
                      onChanged: (v) {
                        userEmail = v;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ).w64(context),
                    10.heightBox,
                    TextField(
                      onChanged: (v) {
                        userMassage = v;
                      },
                      controller: massageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Massage',
                      ),
                    ).w64(context),
                    10.heightBox,
                    CKOutlineButton(
                      onprassed: () {
                        if (userMassage == null ||
                            userEmail == null ||
                            userName == null ||
                            userMassage == '' ||
                            userEmail == '' ||
                            userName == '') {
                          showAlertDialog(context);
                        } else {
                          nameController.clear();
                          emailController.clear();
                          massageController.clear();
                          contactMassageAdd();
                        }
                      },
                      buttonText: "Submit",
                    ),
                  ],
                ),
              ],
            ),
            BottomBar(),
            20.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()),
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
                child:
                    "Contact".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200, 40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
