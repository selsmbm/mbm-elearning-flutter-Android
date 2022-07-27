import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider scrapTableProvider;

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('More'),
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
              if (user!.photoURL!.contains(student) ||
                  user!.photoURL!.contains(teacher))
                SettingButton(
                  onTap: () {
                    Navigator.pushNamed(context, 'bookmark');
                  },
                  title: 'Bookmark',
                  subtitle: 'Manage your bookmarked',
                  icon: Icons.bookmark,
                ),
              if (user!.photoURL!.contains(student))
                SettingButton(
                  onTap: () {
                    Navigator.pushNamed(context, 'gateMaterial');
                  },
                  title: 'GATE SSC Prep.',
                  subtitle: 'All type of exam material',
                  icon: Icons.book,
                ),
              if (user!.photoURL!.contains(student) ||
                  user!.photoURL!.contains(teacher))
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
                  "MBMU",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SettingButton(
                onTap: () {
                  launch('https://mbmec.weebly.com/t--p-cell.html');
                },
                title: 'TPO',
                subtitle: 'Placement, training, and other related',
                icon: Icons.public,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'teachers');
                },
                title: 'Teachers',
                subtitle: 'All teachers of MBMU',
                icon: Icons.group,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'mbmstory');
                },
                title: 'MBM Stories',
                subtitle: 'Powered by mbmstories.com',
                icon: Icons.album,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'map');
                },
                title: 'MBMU Map',
                subtitle: 'Visit college map',
                icon: Icons.map,
              ),
              SettingButton(
                onTap: () {
                  launch(
                      "https://docs.google.com/document/d/1g5F57sM9eEUwFX41JVfKFDQ1iWykeK0AeHauL60lCh8/edit?usp=sharing");
                },
                title: 'Admission processes',
                subtitle: 'Admission processes in MBMU',
                icon: Icons.admin_panel_settings,
              ),
              SettingButton(
                onTap: () {
                  launch(
                      "https://docs.google.com/document/d/1l2KAa2ZPhDJjmMA-uDwi__GHPUyc5zm6ApXB3nNs_xA/edit?usp=sharing");
                },
                title: 'Freshers Guide',
                subtitle: 'Freshers Guide in MBMU',
                icon: Icons.integration_instructions,
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
                  Navigator.pushNamed(context, 'selsAdmins');
                },
                title: 'SELS',
                subtitle: 'All sels mbmbers',
                icon: Icons.supervised_user_circle,
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
              if (scrapTableProvider.checkIsMeSuperAdmin())
                SettingButton(
                  onTap: () {
                    Navigator.pushNamed(context, 'adminDash');
                  },
                  title: 'Admin Dashboard',
                  subtitle: 'Admin dashboard for super admins',
                  icon: Icons.web_sharp,
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // if (prefs.getBool(SP.ismeAdmin) == null ||
                      //     prefs.getBool(SP.ismeAdmin) == false) {
                      //   FirebaseFirestore.instance
                      //       .collection('adminids')
                      //       .get()
                      //       .then((QuerySnapshot querySnapshot) {
                      //     for (var doc in querySnapshot.docs) {
                      //       if (doc["id"] == user!.uid) {
                      //         prefs.setBool(SP.ismeAdmin, true);
                      //         Navigator.pushNamed(context, 'adminDash');
                      //       }
                      //     }
                      //   });
                      // } else {
                      //   if (!mounted) return;
                      //   Navigator.pushNamed(context, 'adminDash');
                      // }
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
