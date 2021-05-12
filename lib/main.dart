import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mbmelearning/mobile/mobiledashbord.dart';
import 'package:mbmelearning/mobile/authrepo/mobilemainScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MBM E-LEARNING',
      theme: ThemeData.light(),
      home: FirebaseAuth.instance.currentUser == null ? MobileMainScreen() : MobileDashbord(),
    );
  }
}
