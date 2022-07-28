import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/more_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.theme}) : super(key: key);
  final ThemeController theme;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ScrapTableProvider scrapTableProvider;
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Settings");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  SharedPreferences prefs = snapshot.data;
                  return SettingButton(
                    onTap: () {
                      Navigator.pushNamed(context, 'more');
                    },
                    title: 'Dark Mode',
                    subtitle: 'Change theme',
                    icon: Icons.color_lens,
                    child: Switch(
                      value: prefs.getBool(SP.darkMode) ?? false,
                      onChanged: (value) {
                        prefs.setBool(SP.darkMode, value);
                        widget.theme.updateThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
          if (scrapTableProvider.checkIsMeSuperAdmin())
            SettingButton(
              onTap: () {
                Navigator.pushNamed(context, 'adminDash');
              },
              title: 'Admin Dashboard',
              subtitle: 'Admin dashboard for super admins',
              icon: Icons.web_sharp,
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
              showAboutDialog(
                context: context,
                applicationName: 'MBM E-Learning',
                applicationVersion: 'v3.0.0',
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                applicationLegalese: 'Copyright © 2020 MBM E-Learning',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: """
                      <p>
                        MBM E-Learning is a application that is used to help teachers, students and alumni to share notes and information.
                      </p>
                      <p>
                        This application is developed by <a href="https://mbmec.weebly.com/">SELS</a> and is licensed under the <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">GNU General Public License v3.0</a>.
                      </p>
                      """,
                    ),
                  ),
                ],
              );
            },
            title: 'About',
            subtitle: 'About this app',
            icon: Icons.info,
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
        ],
      ),
    );
  }
}
