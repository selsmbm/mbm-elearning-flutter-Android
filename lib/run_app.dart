import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/add_college.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/ForgetPassword.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Signin.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/your_uploaded_material_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/Bookmark.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/setting_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Extras/gate_material.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/profile_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/search_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Splash.dart';
import 'package:mbm_elearning/Provider/theme_provider.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:provider/provider.dart';

import 'Data/Repository/post_material_repo.dart';
import 'Presentation/Screens/Dashboard/material/Material.dart';
import 'Presentation/Screens/IntroPages.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
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
  final themeController = ThemeController(ThemeService());
  await themeController.loadSettings();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    systemNavigationBarColor: rPrimaryLiteColor, // status bar color
    statusBarIconBrightness: Brightness.light, // status bar icons' color
    systemNavigationBarIconBrightness:
        Brightness.dark, //navigation bar icons' color
  ));
  return MyApp(
    theme: themeController,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeController theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: theme,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: Flavors.title,
          debugShowCheckedModeBanner: false,
          theme: theme.litethemeData,
          darkTheme: theme.darkthemeData,
          themeMode: theme.themeMode,
          routes: {
            '/': (context) => LandingPage(),
            'signInPage': (context) => SigninPage(),
            'forgetPage': (context) => ForgetPasswordPage(),
            'homePage': (context) => DashboardPage(),
            'home': (context) => HomePage(),
            'setting': (context) => SettingPage(),
            'search': (context) => BlocProvider(
                  create: (context) => GetMaterialApiBloc(
                    GetMaterialRepo(),
                  ),
                  child: SearchPage(),
                ),
            'profile': (context) => ProfilePage(),
            'materialPage': (context) => BlocProvider(
                  create: (context) => GetMaterialApiBloc(
                    GetMaterialRepo(),
                  ),
                  child: MaterialsPage(),
                ),
            'yourmaterialPage': (context) => BlocProvider(
                  create: (context) => GetMaterialApiBloc(
                    GetMaterialRepo(),
                  ),
                  child: YourMaterialPage(),
                ),
            'bookmark': (context) => BookmarkPage(),
            'intro': (context) => OnBoardingPage(),
            'gateMaterial': (context) => GateMaterial(),
            'adminDash': (context) => const AdminDashboard(),
            'addCollege': (context) => AddCollegePage(),
            'addMaterialPage': (context) => BlocProvider(
                  create: (context) => AddDataToApiBloc(
                    PostMaterialRepo(),
                  ),
                  child: AddMaterialPage(),
                ),
          },
          initialRoute: '/',
        );
      },
    );
  }
}
