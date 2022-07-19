import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Setting'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, 'profile');
                },
                leading: CircleAvatar(
                  backgroundColor: rPrimaryLiteColor,
                  child: Text(
                    user?.displayName?.substring(0, 1) ?? 'U',
                    style: TextStyle(
                      fontSize: 25,
                      color: rTextColor,
                    ),
                  ),
                ),
                title: Text(
                  '${user?.displayName ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${user?.uid ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                child: Text(
                  "Extras",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'bookmark');
                },
                title: 'Bookmark',
                subtitle: 'Manage your bookmarked',
                icon: Icons.bookmark,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'gateMaterial');
                },
                title: 'GATE SSC Prep.',
                subtitle: 'All type of exam material',
                icon: Icons.book,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'yourmaterialPage');
                },
                title: 'Your Material',
                subtitle: 'All of your uploaded material',
                icon: Icons.list,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'usefullinks');
                },
                title: 'Useful Links',
                subtitle: 'All useful links',
                icon: Icons.link,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                child: Text(
                  "Utilities",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SettingButton(
                onTap: () {
                  Share.share(
                      'MBM UNIVERSITY Jodhpur   MBM E-learning <SELS>  Hello MBMites,🙋‍♂️ You are Informed that an App is developed for help of our collegeous. In this, you are provided the regular updates  related to University and all type of Notes,Books,Lab files, previous papers etc for every year.  Here is the link :-👇\nhttps://play.google.com/store/apps/details?id=com.mbm.elereaning.mbmecj');
                },
                title: 'Share',
                subtitle: 'Share this app with your friends',
                icon: Icons.share,
              ),
              SettingButton(
                onTap: () {
                  launch(
                      'https://play.google.com/store/apps/details?id=com.mbm.elereaning.mbmecj');
                },
                title: 'Rate this app',
                subtitle: 'Rate this app on playstore',
                icon: Icons.rate_review,
              ),
              SettingButton(
                onTap: () {
                  launch('https://mbmec.weebly.com/');
                },
                title: 'Website',
                subtitle: 'Visit our website',
                icon: Icons.web_sharp,
              ),
              SettingButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text('Do you want to logout?'),
                      actions: [
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                title: 'Logout',
                subtitle: 'Logout from this app',
                icon: Icons.logout,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('admins')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          if (doc["id"] == user!.uid) {
                            Navigator.pushNamed(context, 'adminDash');
                          }
                        }
                      });
                    },
                    child: const Text(
                      "Made With ❤ by SELS.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff9c9191),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  const SettingButton({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: rPrimaryLiteColor,
        child: Icon(
          icon,
          size: 20,
          color: rPrimaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
      ),
    );
  }
}
