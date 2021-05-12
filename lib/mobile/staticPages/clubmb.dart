import 'dart:async';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';



class ClubMB extends StatefulWidget {
  @override
  _ClubMBState createState() => _ClubMBState();
}

class _ClubMBState extends State<ClubMB> {
  BannerAd _bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
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
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            (){
          _bannerAd.show();
        }
    );
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            "Techanical".text.color(kFirstColour).bold.xl3.make(),
            VxBox().color(kFirstColour).size(60, 2).make(),
            10.heightBox,
            "1. Society for Automotive Engineers".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@teamdaruga',
                onPressed: () {
                  launch('https://www.instagram.com/teamdaruga/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@teamdaruga',
                onPressed: () {
                  launch('https://www.facebook.com/search/top?q=team%20daruga');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                ),
                tooltip: '@mbmsaeindiacollegiateclub',
                onPressed: () {
                  launch('https://t.me/mbmsaeindiacollegiateclub');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.email_outlined,
                ),
                tooltip: 'mbmsaeindiacollegiateclub@gmail.com',
                onPressed: () {
                  launch('mailto:mbmsaeindiacollegiateclub@gmail.com');
                },
              ),
            ]),
            "We are a group of students from MBM Engineering College, Jodhpur, which design, fabricate and test ALL-TERRAIN VEHICLES (ATV) for BAJA SAE INDIA".text.make(),
            10.heightBox,
            "Hello Enthusiasts,".text.xl.make(),
            10.heightBox,
            "We believe in making dreams come true , we believe in becoming and making the best. We bring to you , the best of our creations...The dreams on wheels ...."
          "We work on ATV manufacturing with core team specialized in CAD Modeling , Power Transmission , Sunpension , Wheels and so on."
      "US ; The conquerors, strive hard to excogitate pinnacle in extending wheels to the dreams."
      "We ; the challengers pledge to create Magnum Opus , in the field of designing and fabricating the transcendent ATV'S."
      "Follow Our Social Media handles to get updated with Automobile World."
          "we organizes different activities like Workshop, Expert talks, Industrial visits, Students meet, Technical events etc."
      "Also we will form teams for different national level competitions like BAJA,SUPRA, efficycle etc."
      "Always believe in yourself."
      "Regards :- Hitesh patel sir (Faculty Advisor)"
      "For any query feel free to Contact Urjasvita Gaur, (Captain).".text.make(),
            20.heightBox,
            "2. DEVELPOER STUDENT CLUBS".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@@dsc_mbm',
                onPressed: () {
                  launch('https://www.instagram.com/dsc_mbm/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@dsc_mbm',
                onPressed: () {
                  launch('https://www.facebook.com/dscmbm');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.linkedin_square,
                ),
                tooltip: '@dsc_mbm',
                onPressed: () {
                  launch('https://www.linkedin.com/company/dsc-mbm/');
                },
              ),
              IconButton(
                icon: Icon(
                  CommunityMaterialIcons.web,
                ),
                tooltip: '@dsc_mbm',
                onPressed: () {
                  launch('https://developers.google.com/community/dsc?fbclid=IwAR3yLdof7n1tELEh10EeT4ZJr7jjPNSxvyDFJfMQkK_9dF-nG4uFXluYAGE');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.youtube,
                ),
                tooltip: '@dsc_mbm',
                onPressed: () {
                  launch('https://www.youtube.com/channel/UCst10ztNeGqSUiMJlcrV9Sw/featured');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                ),
                tooltip: '@dsc_mbm',
                onPressed: () {
                  launch('https://t.me/joinchat/NnesB1D94xXUXRvI5S3VKA');
                },
              ),
            ]),
            10.heightBox,
            "Hello everyone, When all tech-savvy's come together, they revolutionize the world! With this belief, Introducing,"
          "Developer Student Clubs for the very first time at MBM Engineering College!"
      "This community is for students who are interested in Google developer technologies. All who are enrolled in undergraduate or graduate programs with an interest in growing as a developer are heartily welcome. In DSC, students grow their knowledge in a peer-to-peer learning environment and build world-class solutions for local businesses and their community."
          "For any queries, feel free to contact Pranoy Bhansali, Lead - DSC MBM".text.make(),
            20.heightBox,
            "3. Embedded Systems and Robotics Club".text.color(kFirstColour).bold.xl2.make(),
            10.heightBox,
          HStack([
            IconButton(
              icon: Icon(
                CommunityMaterialIcons.discord,
              ),
              onPressed: () {
                launch('https://discord.gg/kxXbz8EF');
              },
            ),
            ]),
            "​Hello everyone . Welcome to The Embedded Systems and Robotics Club (ESRC). We hope you all are highly anticipated to be a part of it. So here we share the registration form for the same. Do ensure maximum participation both mentally and physically.Team ESRC robot".text.make(),
          20.heightBox,
          "4. CodeChef MBM Chapter".text.color(kFirstColour).bold.xl2.make(),
          HStack([
            IconButton(
              icon: Icon(
                AntDesign.instagram,
              ),
              tooltip: '@codechef_mbm',
              onPressed: () {
                launch('https://www.instagram.com/codechef_mbm/');
              },
            ),
            IconButton(
              icon: Icon(
                AntDesign.facebook_square,
              ),
              tooltip: '@CodeChefMBM',
              onPressed: () {
                launch('https://www.facebook.com/CodeChefMBM');
              },
            ),
            IconButton(
              icon: Icon(
                CommunityMaterialIcons.discord,
              ),
              onPressed: () {
                launch('https://discord.com/channels/776739440957063168/776739440957063172');
              },
            ),
            ]),
            "The rasode of CodeChef is officially on our Campus now!"
          "We’re glad to announce the opening of the CodeChef MBM Chapter."
      "The mission of the Chapter is to build a robust Competitive Programming culture in the college campus 💻."
          "Let’s Practice, Compete, Share, Discuss, and Grow together!"
          "To be part of our community, join our discord server and follow our social media handles.".text.make(),
            20.heightBox,
            "Non-Techanical".text.color(kFirstColour).bold.xl3.make(),
            VxBox().color(kFirstColour).size(60, 2).make(),
            10.heightBox,
            "OUR CULTURE IS OUR STRENGTH BE IT MUSIC, DANCE, POETRY OR ANYTHING, AND THESE ARE VERY PRECIOUS".text.make(),
            20.heightBox,
            "1. PRATIBIMB".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@pratibimb_mbm',
                onPressed: () {
                  launch('https://www.instagram.com/pratibimb_mbm/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@pratibimb.mbm',
                onPressed: () {
                  launch('https://www.facebook.com/pratibimb.mbm');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.youtube,
                ),
                onPressed: () {
                  launch('https://www.youtube.com/channel/UCL7xK3TX8Gnh20po9qmxoQw');
                },
              ),
            ]),
            "The Theatre Club (ICC)\nMBM Engineering College \nMeet timings-4.00pm \n@ Alumni Association Building".text.make(),
            20.heightBox,
            "2. ZENITH".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@___zenith__',
                onPressed: () {
                  launch('https://www.instagram.com/___zenith__/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@zenith.heights',
                onPressed: () {
                  launch('https://www.facebook.com/zenith.heights');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.youtube,
                ),
                onPressed: () {
                  launch('https://www.youtube.com/channel/UCIs-w1zd2UI949zdGMh6bQw');
                },
              ),
            ]),
            "Dance group : MBM College, Jodhpur".text.make(),
            20.heightBox,
            "3. DEBATING CLUB".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@debatingclub_mbm',
                onPressed: () {
                  launch('https://www.instagram.com/debatingclub_mbm/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@DCMBM',
                onPressed: () {
                  launch('https://www.facebook.com/DCMBM');
                },
              ),
            ]),
            "\"ना सम्मान का मोह, ना अपमान का भय\" "
      "The literary society of MBM Engineering College, Jodhpur."
      "Running in M.B.M Engineering College since 1976 , Debating Club is ceaselessly working on the soft skills of students . Its prime motive is to provide a platform to students in order to groom their communication skills, which is indispensable in all walks of life.".text.make(),
            20.heightBox,
            "4. SARGAM".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@sargam_mbm',
                onPressed: () {
                  launch('https://www.instagram.com/sargam_mbm/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@ICCsargam',
                onPressed: () {
                  launch('https://www.facebook.com/ICCsargam');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.youtube,
                ),
                onPressed: () {
                  launch('https://www.youtube.com/channel/UCzUEPheFYHKhSFW5zEhiq1g');
                },
              ),
            ]),
            "Sargam, A Musical Bliss"
          "The Music Club of M.B.M. Engineering College, Jodhpur"
          "ICC This is the Music Club of Innovative & Creative Clubs (ICC) of M.B.M. Engineering College, Jodhpur."
    "Here, we learn to nurture our music skills with peer to peer learning and create a healthy atmosphere in which every music lover can enjoy heartily.​".text.make(),
            20.heightBox,
            "5. ALANKAR".text.color(kFirstColour).bold.xl2.make(),
            HStack([
              IconButton(
                icon: Icon(
                  AntDesign.instagram,
                ),
                tooltip: '@mbm_alankaar',
                onPressed: () {
                  launch('https://www.instagram.com/mbm_alankaar/');
                },
              ),
              IconButton(
                icon: Icon(
                  AntDesign.facebook_square,
                ),
                tooltip: '@alankaarmbm',
                onPressed: () {
                  launch('https://www.facebook.com/alankaarmbm');
                },
              ),
            ]),
            "Literary branch of ICC\n"
            "\"सिर्फ हंगामा खड़ा करना मेरा मकसद नहीं\nमेरी कोशिश है कि सूरत बदलनी चाहिए\"\n"
          "एम बी एम इंजीनियरिंग कॉलेज के सांस्कृतिक क्लब आई.सी. सी. की साहित्यिक शाखा"
          "प्रस्तुत क्लब की स्थापना इंजीनियरिंग कॉलेज में साहित्य की आवश्यकताओं को पूर्ण करने हेतु की गयी है| इसकी नियमित बैठकों में लगभग साहित्य की समस्त विधाओं जैसे शायरी , कविता ,कहानी,व्यंग्य, किस्सागोई व् मंच संचालन के विभिन्न पहलुओं पर विमर्श व् चिंतन किया जाता है|"
      "इस क्लब की संयोजक,मार्गदर्शक व् पथ प्रदर्शक इलेक्ट्रिकल विभाग की एसोसिएट प्रोफेसर डॉ जयश्री वाजपेयी मैडम हैं जिनकी छत्र छाया में कॉलेज के सांस्कृतिक क्लब आई सी सी के बैनर तले \"अलंकार\" विगत पांच वर्षों से पुष्पित पल्लवित हो रहा है|".text.make(),
            20.heightBox,
            BottomBar(),
            20.heightBox,
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()).p(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: VxBox(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50,40).make(),
              ),
              VxBox(
                child: "Clubs".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(100,40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
