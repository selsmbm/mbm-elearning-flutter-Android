import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/event_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/events_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/feed/feed_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/feed/feed_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/more_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:update_available/update_available.dart';
import 'package:update_available_platform_interface/update_available_platform_interface.dart';

LocalDbConnect localDbConnect = LocalDbConnect();
final StreamController<bool> scrapSubscriptionIsGettingData =
    StreamController<bool>();

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
  bool extended = false;
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
    if (!kIsWeb) {
      localDbConnect.asyncInit();
    }
    setNotifications();
    setCurrentScreenInGoogleAnalytics('Dashboard Page');
    checkForUpdate();
    if (!kIsWeb) initDynamicLinks();
  }

  Future initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      dynamicLinkWorker(dynamicLink);
    }).onError((error) {
      log(error);
    });
    PendingDynamicLinkData? dynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (dynamicLink != null) {
      dynamicLinkWorker(dynamicLink);
    }
  }

  dynamicLinkWorker(PendingDynamicLinkData dynamicLink) {
    scrapSubscriptionIsGettingData.stream.listen((isGetting) {
      if (!isGetting) {
        final Uri deepLink = dynamicLink.link;
        var params = deepLink.queryParameters;
        String purpose = params['purpose'] ?? "";
        if (purpose == DL.feeds) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FeedDetailsPage(feedId: int.parse(params['id']!));
              },
            ),
          );
        } else if (purpose == DL.event) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EventDetailsPage(eventId: int.parse(params['id']!));
              },
            ),
          );
        } else if (purpose == DL.explore) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ExploreDetailsPage(
                  exploreId: int.parse(params['id']!),
                );
              },
            ),
          );
        }
      }
    });
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
    if (!kIsWeb) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("${message.data['title']}: ${message.data['body']}"),
      ));
    }
  }

  checkForUpdate() async {
    if (!kIsWeb) {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        try {
          await getUpdateAvailability().then((value) {
            value.fold(
              available: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: AlertDialog(
                      title: const Text('Update available!'),
                      content: const Text(
                          'Please update this app for new features.'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () async {
                            launch(
                                'https://play.google.com/store/apps/details?id=${Flavors.package}');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              notAvailable: () {},
              unknown: () {},
            );
          });
        } catch (e) {
          print("Error");
          print(e);
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrapTableProvider.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(user!.photoURL!);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (scrapTableProvider.banner1 != null)
              if (scrapTableProvider.banner1!['status'] == true)
                InkWell(
                  onTap: () {
                    launch(scrapTableProvider.banner1!['url']);
                  },
                  child: Image.network(
                    scrapTableProvider.banner1!['image'],
                  ),
                ),
            MediaQuery.of(context).size.width > 750
                ? const SizedBox()
                : NavigationBar(
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
          ],
        ),
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width > 750)
              NavigationRail(
                minExtendedWidth: 150,
                leading: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          extended = !extended;
                        });
                      },
                      icon: const Icon(
                        Icons.menu,
                      ),
                    ),
                  ],
                ),
                extended: extended,
                useIndicator: true,
                selectedIndex: currentIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                destinations: <NavigationRailDestination>[
                  if (user!.photoURL!.contains(student) ||
                      user!.photoURL!.contains(teacher))
                    const NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.feed_outlined),
                    selectedIcon: Icon(Icons.feed),
                    label: Text('Feeds'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('Explore'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.event_available_outlined),
                    selectedIcon: Icon(Icons.event_available),
                    label: Text('Events'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.more_horiz_outlined),
                    selectedIcon: Icon(Icons.more_horiz),
                    label: Text('More'),
                  ),
                ],
              ),
            Expanded(
              child: ModalProgressHUD(
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
          ],
        ),
      ),
    );
  }
}

const platform = MethodChannel('me.mateusfccp/update_available');

Future<Availability> getUpdateAvailability() async {
  try {
    final available = await platform.invokeMethod('getUpdateAvailability');
    return available ? UpdateAvailable : NoUpdateAvailable;
  } on PlatformException {
    return UnknownAvailability;
  }
}
