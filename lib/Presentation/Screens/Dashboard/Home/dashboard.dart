import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/setting_page.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:update_available/update_available.dart';

LocalDbConnect localDbConnect = LocalDbConnect();

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late FirebaseMessaging messaging;
  List<Widget> _pages = [
    HomePage(),
    Container(),
    Container(),
    SettingPage(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    localDbConnect.asyncInit();
    setCurrentScreenInGoogleAnalytics('Dashboard Page');
    // try {
    //   messaging = FirebaseMessaging.instance;
    //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             title: Text(event.notification.title),
    //             content: Linkify(
    //               text: event.notification.body,
    //               onOpen: (l) {
    //                 launch(l.url);
    //               },
    //             ),
    //             actions: [
    //               TextButton(
    //                 child: const Text("Ok"),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //               )
    //             ],
    //           );
    //         });
    //   });
    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     print('Message clicked!');
    //   });
    // } on Exception catch (e) {
    //   print(e);
    // }
    checkForUpdate();
  }

  checkForUpdate() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      await getUpdateAvailability().then((value) {
        value.fold(
          available: () {
            log('update is available for your app.');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Update available!'),
                content: Text('Please update this app for new features.'),
                actions: [
                  TextButton(
                    child: Text('Later'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () async {
                      launch(
                          'https://play.google.com/store/apps/details?id=${Flavors.package}');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          notAvailable: () {
            log('No update is available for your app.');
          },
          unknown: () =>
              log("It was not possible to determine if there is or not "
                  "an update for your app."),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.feed_outlined),
              selectedIcon: Icon(Icons.feed),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ]),
      body: _pages[_currentIndex],
    );
  }
}
