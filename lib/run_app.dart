
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:mbm_elearning/Presentation/Screens/Admin/verified_users.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/ForgetPassword.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Signin.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/useful_links.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/your_uploaded_material_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/events_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/feed/feed_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/mbm_story/mbm_stories.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/teachers/teacher_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/teachers/teachers_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/achievements/achievements_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/add_new_event.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/add_new_explore.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/add_new_feed_post.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/SubAdmin/achievements/request_achievements_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/Bookmark.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/more_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/gate_material.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/search_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/utilities/mbm_map.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/utilities/sels_admins/sels_admins_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/utilities/settings_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Splash.dart';
import 'package:mbm_elearning/Presentation/Widgets/html_editor.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Provider/theme_provider.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Data/Repository/post_material_repo.dart';
import 'Presentation/Screens/Dashboard/material/Material.dart';
import 'Presentation/Screens/IntroPages.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (!kIsWeb) {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}

Future<Widget> runMainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: 'AIzaSyDAJoQfqX7XVEShds_pw-mBLx3uOo2yldM',
            authDomain: 'mbmecj.firebaseapp.com',
            databaseURL: 'https://mbmecj.firebaseio.com',
            projectId: 'mbmecj',
            storageBucket: 'mbmecj.appspot.com',
            messagingSenderId: '304334437374',
            appId: '1:304334437374:web:2cd637b99eb3c8d8f29eaf',
            measurementId: 'G-MGLBGX8E73',
          )
        : null,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  if (!kIsWeb) {
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
  }
  final themeController = ThemeController();
  await themeController.loadSettings();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    systemNavigationBarColor: themeController.themeMode == ThemeMode.dark
        ? rPrimaryDarkLiteColor
        : rPrimaryLiteColor, // status bar color
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
    if (!kIsWeb) {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: NotificationController.onActionReceivedMethod,
          onNotificationCreatedMethod:
              NotificationController.onNotificationCreatedMethod,
          onNotificationDisplayedMethod:
              NotificationController.onNotificationDisplayedMethod,
          onDismissActionReceivedMethod:
              NotificationController.onDismissActionReceivedMethod);
    }
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
                  return MaterialPageRoute(builder: (context) => const LandingPage());
                case 'signInPage':
                  return MaterialPageRoute(builder: (context) => const SigninPage());
                case 'forgetPage':
                  return MaterialPageRoute(
                      builder: (context) => ForgetPasswordPage());
                case 'dashboard':
                  return MaterialPageRoute(
                      builder: (context) => const DashboardPage());
                case 'home':
                  return MaterialPageRoute(builder: (context) => const HomePage());
                case 'feeds':
                  return MaterialPageRoute(builder: (context) => const FeedsPage());
                case 'events':
                  return MaterialPageRoute(builder: (context) => const EventsPage());
                case 'achievementPage':
                  return MaterialPageRoute(
                      builder: (context) => const AchievementsPage());
                case 'VerifiedUsers':
                  return MaterialPageRoute(
                      builder: (context) => const VerifiedUsers());
                case 'request_achievement_page':
                  return MaterialPageRoute(
                      builder: (context) => const RequestAchievementPage());
                case 'more':
                  return MaterialPageRoute(builder: (context) => const MorePage());
                case 'map':
                  return MaterialPageRoute(builder: (context) => const MBMMap());
                case 'search':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: const SearchPage(),
                          ));
                case 'profile':
                  return MaterialPageRoute(builder: (context) => const ProfilePage());
                case 'teachers':
                  return MaterialPageRoute(
                      builder: (context) => const TeachersPage());
                case 'teacherdetails':
                  return MaterialPageRoute(
                      builder: (context) => const TeacherDetails());
                case 'mbmstory':
                  return MaterialPageRoute(builder: (context) => const MBMStories());
                case 'usefullinks':
                  return MaterialPageRoute(
                      builder: (context) => const UsefulLinksPage());
                case 'materialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: const MaterialsPage(),
                          ));
                case 'yourmaterialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: const YourMaterialPage(),
                          ));
                case 'approvematerialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => GetMaterialApiBloc(
                              GetMaterialRepo(),
                            ),
                            child: const ApproveMaterialPage(),
                          ));
                case 'bookmark':
                  return MaterialPageRoute(
                      builder: (context) => const BookmarkPage());
                case 'intro':
                  return MaterialPageRoute(
                      builder: (context) => OnBoardingPage());
                case 'gateMaterial':
                  return MaterialPageRoute(
                      builder: (context) => const GateMaterial());
                case 'adminDash':
                  return MaterialPageRoute(
                      builder: (context) => const AdminDashboard());
                case 'sendnotitoall':
                  return MaterialPageRoute(
                      builder: (context) => const SendNotificationToAllPage());
                case 'html_editor':
                  return MaterialPageRoute(
                      builder: (context) => const HtmlEditorScreen());
                case 'addNewFeed':
                  return MaterialPageRoute(
                      builder: (context) => const AddNewFeedPage());
                case 'addNewExplore':
                  return MaterialPageRoute(
                      builder: (context) => const AddNewExplorePage());
                case 'addNewEvent':
                  return MaterialPageRoute(
                      builder: (context) => const AddNewEventPage());
                case 'selsAdmins':
                  return MaterialPageRoute(
                      builder: (context) => const SELSAdminsPage());
                case 'settings':
                  return MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            theme: widget.theme,
                          ));
                case 'addMaterialPage':
                  return MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => AddDataToApiBloc(
                              PostMaterialRepo(),
                            ),
                            child: const AddMaterialPage(),
                          ));
                default:
                  return MaterialPageRoute(
                      builder: (context) => const DashboardPage());
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
          builder: (context) => const DashboardPage(
            initialRout: 1,
          ),
        ),
        (route) =>
            route ==
            MaterialPageRoute(
              builder: (context) => const LandingPage(),
            ),
      );
    } else {
      MyApp.navigatorKey.currentState!
          .pushNamed(data['redirectPage']!, arguments: receivedAction);
    }
  }
}
