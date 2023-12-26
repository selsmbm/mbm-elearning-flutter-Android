import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider scrapTableProvider;
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("More Page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('More'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () async {
                  var out = await Navigator.pushNamed(context, 'profile');
                  if (out != null) {
                    setState(() {});
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: rPrimaryLiteColor,
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName
                            ?.substring(0, 1) ??
                        'U',
                    style: const TextStyle(
                      fontSize: 25,
                      color: rTextColor,
                    ),
                  ),
                ),
                title: Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user?.uid ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                child: Text(
                  "Extras",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              if (!kIsWeb)
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
                  Navigator.pushNamed(context, 'achievementPage');
                },
                title: 'Achievements',
                subtitle: 'Explore admin',
                icon: Icons.privacy_tip,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'usefullinks');
                },
                title: 'Useful Links',
                subtitle: 'All useful links',
                icon: Icons.link,
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                title: 'MBM stories',
                subtitle: 'Powered by mbmstories.com',
                icon: Icons.album,
              ),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'map');
                },
                title: 'MBMU campus',
                subtitle: 'Visit college campus',
                icon: Icons.map,
              ),
              if (user!.photoURL!.contains(student))
                SettingButton(
                  onTap: () {
                    launch(
                        "https://docs.google.com/document/d/1g5F57sM9eEUwFX41JVfKFDQ1iWykeK0AeHauL60lCh8/edit?usp=sharing");
                  },
                  title: 'Admission processes',
                  subtitle: 'Admission processes in MBMU',
                  icon: Icons.admin_panel_settings,
                ),
              if (user!.photoURL!.contains(student))
                SettingButton(
                  onTap: () {
                    launch(
                        "https://docs.google.com/document/d/1l2KAa2ZPhDJjmMA-uDwi__GHPUyc5zm6ApXB3nNs_xA/edit");
                  },
                  title: 'Freshers guide',
                  subtitle: 'Freshers Guide in MBMU',
                  icon: Icons.integration_instructions,
                ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                subtitle: 'All SELS members',
                icon: Icons.supervised_user_circle,
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
                  launch('https://sels-mbm.blogspot.com/');
                },
                title: 'Feed dump',
                subtitle: 'All feed post dump database',
                icon: Icons.feed,
              ),
              SettingButton(
                  onTap: () {
                    launch('https://www.buymeacoffee.com/mbmec');
                  },
                  title: 'Donate',
                  subtitle: 'Donate to keep it alive',
                  icon: Icons.money),
              SettingButton(
                onTap: () {
                  Navigator.pushNamed(context, 'settings');
                },
                title: 'Settings',
                subtitle: 'Theme, share, rate us, etc.',
                icon: Icons.settings,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
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
  final Widget? child;
  const SettingButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
  });

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
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
      trailing: child ??
          const Icon(
            Icons.keyboard_arrow_right,
          ),
    );
  }
}
