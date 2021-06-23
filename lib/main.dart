import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mbmelearning/SplashScreen.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MBM E-LEARNING',
      theme: ThemeData.light(),
      home: LandingPage(),
    );
  }
}
