import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/events_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/feed/feed_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/more_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:mbm_elearning/run_app.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:update_available/update_available.dart';

LocalDbConnect localDbConnect = LocalDbConnect();

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, this.initialRout}) : super(key: key);
  final int? initialRout;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider scrapTableProvider;
  late FirebaseMessaging messaging;
  late List<Widget> _pages;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _pages = [
      if (user!.photoURL!.contains(student) ||
          user!.photoURL!.contains(teacher))
        const HomePage(),
      const FeedsPage(),
      const ExplorePage(),
      const EventsPage(),
      const MorePage(),
    ];
    currentIndex = widget.initialRout ?? 0;
    localDbConnect.asyncInit();
    setNotifications();
    setCurrentScreenInGoogleAnalytics('Dashboard Page');
    checkForUpdate();
  }

  setNotifications() {
    forgroundNotification();
    backgroundNotification();
    terminateNotification();
  }

  forgroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        notification(message);
      },
    );
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        notification(message);
      },
    );
  }

  terminateNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      notification(message);
    }
  }

  void notification(RemoteMessage message) {
    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: Random().nextInt(1000),
    //     channelKey: feedNotificationChannel,
    //     title: message.notification!.title,
    //     body: message.notification!.body,
    //     roundedLargeIcon: true,
    //     backgroundColor: rPrimaryLiteColor,
    //     largeIcon: message.data['image'],
    //     category: NotificationCategory.Message,
    //     payload: message.data as Map<String, String>,
    //   ),
    // );
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }

  checkForUpdate() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      await getUpdateAvailability().then((value) {
        value.fold(
          available: () {
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
          notAvailable: () {},
          unknown: () {},
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            destinations: [
              if (user!.photoURL!.contains(student) ||
                  user!.photoURL!.contains(teacher))
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
              const NavigationDestination(
                icon: Icon(Icons.feed_outlined),
                selectedIcon: Icon(Icons.feed),
                label: 'Feeds',
              ),
              const NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Explore',
              ),
              const NavigationDestination(
                icon: Icon(Icons.event_available_outlined),
                selectedIcon: Icon(Icons.event_available),
                label: 'Events',
              ),
              const NavigationDestination(
                icon: Icon(Icons.more_horiz_outlined),
                selectedIcon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ]),
        body: ModalProgressHUD(
          inAsyncCall: scrapTableProvider.isGettingData,
          progressIndicator: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(width: 80, child: LinearProgressIndicator()),
              SizedBox(height: 10),
              Text(
                'Getting data from server',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          child: _pages[currentIndex],
        ),
      ),
    );
  }
}
