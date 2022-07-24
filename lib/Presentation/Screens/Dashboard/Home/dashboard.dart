import 'dart:developer';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/Repository/send_notification.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';
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
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:update_available/update_available.dart';

LocalDbConnect localDbConnect = LocalDbConnect();

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ScrapTableProvider scrapTableProvider;
  late FirebaseMessaging messaging;
  final List<Widget> _pages = [
    const HomePage(),
    const FeedsPage(),
    const ExplorePage(),
    const EventsPage(),
    const MorePage(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
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
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: Random().nextInt(1000),
      channelKey: feedNotificationChannel,
      title: message.notification!.title,
      body: message.notification!.body,
      roundedLargeIcon: true,
      backgroundColor: rPrimaryLiteColor,
      largeIcon: message.data['image'],
      category: NotificationCategory.Message,
    ));
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
              label: 'Feeds',
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_available_outlined),
              selectedIcon: Icon(Icons.event_available),
              label: 'Events',
            ),
            NavigationDestination(
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
        child: _pages[_currentIndex],
      ),
    );
  }
}
