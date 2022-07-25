import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/approve_material.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/send_only_notification.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/ForgetPassword.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Signin.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/useful_links.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/your_uploaded_material_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/events_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/feed/feed_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/mbm_story/mbm_stories.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/teachers/teacher_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/teachers/teachers_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/add_new_feed_post.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/Bookmark.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/more_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/gate_material.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/search_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Splash.dart';
import 'package:mbm_elearning/Presentation/Widgets/html_editor.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Provider/theme_provider.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'Data/Repository/post_material_repo.dart';
import 'Presentation/Screens/Dashboard/material/Material.dart';
import 'Presentation/Screens/IntroPages.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<Widget> runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'mbmecj',
      // options: const FirebaseOptions(
      //   apiKey: 'AIzaSyDAJoQfqX7XVEShds_pw-mBLx3uOo2yldM',
      //   authDomain: 'mbmecj.firebaseapp.com',
      //   databaseURL: 'https://mbmecj.firebaseio.com',
      //   projectId: 'mbmecj',
      //   storageBucket: 'mbmecj.appspot.com',
      //   messagingSenderId: '304334437374',
      //   appId: '1:304334437374:web:2cd637b99eb3c8d8f29eaf',
      //   measurementId: 'G-MGLBGX8E73',
      // ),
      );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher_icon',
      [
        NotificationChannel(
          channelShowBadge: true,
          importance: NotificationImportance.Default,
          channelKey: progressNotificationChannel,
          vibrationPattern: lowVibrationPattern,
          channelName: 'Upload notifications',
          channelDescription:
              'All upload documents notifications show through this channel',
          defaultPrivacy: NotificationPrivacy.Private,
        ),
        NotificationChannel(
          channelGroupKey: groupNotificationChannelKey,
          channelKey: feedNotificationChannel,
          channelName: 'Feed notifications',
          channelDescription:
              'All feed notifications show through this channel',
          groupKey: feedNotificationChannel,
          groupSort: GroupSort.Desc,
          groupAlertBehavior: GroupAlertBehavior.Children,
          defaultColor: rPrimaryColor,
          ledColor: rPrimaryColor,
          vibrationPattern: highVibrationPattern,
          channelShowBadge: true,
          importance: NotificationImportance.High,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: groupNotificationChannelKey,
          channelGroupName: 'Feed notifications',
        ),
      ],
      debug: Flavors.appFlavor == Flavor.MDEV);
  final themeController = ThemeController(ThemeService());
  await themeController.loadSettings();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    systemNavigationBarColor: rPrimaryLiteColor, // status bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
    systemNavigationBarIconBrightness:
        Brightness.dark, //navigation bar icons' color
  ));
  return MyApp(
    theme: themeController,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final ThemeController theme;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.theme,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ScrapTableProvider())
          ],
          child: MaterialApp(
            title: Flavors.title,
            navigatorKey: MyApp.navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: widget.theme.litethemeData,
            darkTheme: widget.theme.darkthemeData,
            themeMode: widget.theme.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              final args = settings.arguments;
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (context) => LandingPage());
                case 'signInPage':
                  return MaterialPageRoute(builder: (context) => SigninPage());
                case 'forgetPage':
                  return MaterialPageRoute(
                      builder: (context) => ForgetPasswordPage());
                case 'dashboard':
                  return MaterialPageRoute(
                      builder: (context) => DashboardPage());
                case 'home':
                  return MaterialPageRoute(builder: (context) => HomePage());
                case 'feeds':
                  return MaterialPageRoute(builder: (context) => FeedsPage());
                case 'events':
                  return MaterialPageRoute(builder: (context) => EventsPage());
                case 'more':
                  return MaterialPageRoute(builder: (context) => MorePage());
                case 'search':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: SearchPage(),
                          ));
                case 'profile':
                  return MaterialPageRoute(builder: (context) => ProfilePage());
                case 'teachers':
                  return MaterialPageRoute(
                      builder: (context) => TeachersPage());
                case 'teacherdetails':
                  return MaterialPageRoute(
                      builder: (context) => TeacherDetails());
                case 'mbmstory':
                  return MaterialPageRoute(builder: (context) => MBMStories());
                case 'usefullinks':
                  return MaterialPageRoute(
                      builder: (context) => UsefulLinksPage());
                case 'materialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: MaterialsPage(),
                          ));
                case 'yourmaterialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: YourMaterialPage(),
                          ));
                case 'approvematerialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: ApproveMaterialPage(),
                          ));
                case 'bookmark':
                  return MaterialPageRoute(
                      builder: (context) => BookmarkPage());
                case 'intro':
                  return MaterialPageRoute(
                      builder: (context) => OnBoardingPage());
                case 'gateMaterial':
                  return MaterialPageRoute(
                      builder: (context) => GateMaterial());
                case 'adminDash':
                  return MaterialPageRoute(
                      builder: (context) => const AdminDashboard());
                case 'sendnotitoall':
                  return MaterialPageRoute(
                      builder: (context) => const SendNotificationToAllPage());
                case 'html_editor':
                  return MaterialPageRoute(
                      builder: (context) => HtmlEditorScreen());
                case 'addNewFeed':
                  return MaterialPageRoute(
                      builder: (context) => AddNewFeedPage());
                case 'addMaterialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => AddDataToApiBloc(
                              PostMaterialRepo(),
                            ),
                            child: AddMaterialPage(),
                          ));
                default:
                  return MaterialPageRoute(
                      builder: (context) => DashboardPage());
              }
            },
          ),
        );
      },
    );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    Map<String, String?> data = receivedAction.payload!;

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    if (data['redirectPage']! == "launchUrl") {
      if (data['url']!.contains("http")) {
        launchUrl(Uri.parse(data['url']!),
            mode: LaunchMode.externalApplication);
      }
    } else if (data['redirectPage']! == "feeds") {
      MyApp.navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            initialRout: 1,
          ),
        ),
        (route) =>
            route ==
            MaterialPageRoute(
              builder: (context) => LandingPage(),
            ),
      );
    } else {
      MyApp.navigatorKey.currentState!
          .pushNamed(data['redirectPage']!, arguments: receivedAction);
    }
  }
}
