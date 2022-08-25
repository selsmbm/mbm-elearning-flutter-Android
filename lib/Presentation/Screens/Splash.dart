import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Signin.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:mbm_elearning/Presentation/Screens/IntroPages.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final User? _auth = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider scrapTableProvider;

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      if (_auth == null) {
        if (kIsWeb) {
          Timer(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SigninPage()));
          });
        } else {
          Timer(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => OnBoardingPage()));
          });
        }
      } else {
        if (prefs.getBool(SP.initialProfileSaved) != null ||
            prefs.getBool(SP.initialProfileSaved) != false) {
          Timer(const Duration(seconds: 1), () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          });
        } else {
          Timer(const Duration(seconds: 1), () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(
                  isItInitialUpdate: true,
                ),
              ),
            );
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('No internet'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
    setCurrentScreenInGoogleAnalytics('Splash Page');
  }

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    scrapTableProvider.scrapAllData();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'MBM E-Learning',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Righteous',
                    color: Theme.of(context).primaryColor ==
                            rPrimaryMaterialColorLite
                        ? rPrimaryColor
                        : Colors.white,
                  ),
                ),
              ],
            ),
            const Text("Made With ❤ by SELS"),
          ],
        ),
      ),
    );
  }
}
