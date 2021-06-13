import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mbmelearning/Widgets/AlertDialog.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/appheader.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:mbmelearning/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ContactMobile extends StatefulWidget {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

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

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: ContactMobile.targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: kBannerAdsId);
    _bannerAd = createBannerAd()..load();
  }
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final massageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      _bannerAd.show();
    });
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
                          image: AssetImage('assets/lokesh.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Lokesh Jangid".text.xl2.make(),
                    "Electrical Engineering".text.gray500.make(),
                    "lkrjangid@gmail.com".text.gray500.make(),
                    FlatButton(
                      onPressed: () {},
                      child: Icon(
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
                          image: NetworkImage('https://media-exp1.licdn.com/dms/image/C5603AQFqh_Yy0Wcu4A/profile-displayphoto-shrink_400_400/0/1593108247402?e=1628121600&v=beta&t=BKNze0PdijQRlONxCRGCmRO0zvK1uJK_m9YZfSBgGlQ'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Kapil Gupta".text.xl2.make(),
                    "Civil Engineering".text.gray500.make(),
                    "guptakapil24000@gmail.com".text.gray500.make(),
                    FlatButton(
                      onPressed: () {},
                      child: Icon(
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
                          image: NetworkImage('https://media-exp1.licdn.com/dms/image/C4E03AQFjn-uaiJWO1w/profile-displayphoto-shrink_400_400/0/1610263761229?e=1628121600&v=beta&t=ZwyObu64Djbpjo0y3PXK5DyIHJBktwxFf0vnPYc3rRg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    "Kashish Agarawal".text.xl2.make(),
                    "Civil Engineering".text.gray500.make(),
                    "kashishagrawal0005@gmail.com".text.gray500.make(),
                    FlatButton(
                      onPressed: () {},
                      child: Icon(
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
