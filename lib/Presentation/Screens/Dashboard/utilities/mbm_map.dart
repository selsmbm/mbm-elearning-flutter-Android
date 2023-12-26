import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Widgets/html_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class MBMMap extends StatefulWidget {
  const MBMMap({super.key, this.url, this.title});
  final String? url;
  final String? title;
  @override
  State<MBMMap> createState() => _MBMMapState();
}

class _MBMMapState extends State<MBMMap> {
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics(widget.title ?? "MBM Map");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    showTutorial();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'MBM campus'),
        actions: [
          IconButton(
            key: openInBrowser,
            onPressed: () {
              launch(
                  'https://www.google.com/maps/d/u/0/viewer?mid=1_Wg8w4EujrRyn9PHpoZdT1pvy73Pwvc');
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: HtmlViewer(
        data: """
<iframe src="${widget.url ?? "https://www.google.com/maps/d/embed?mid=1_Wg8w4EujrRyn9PHpoZdT1pvy73Pwvc&ehbc=2E312F&z=15"}" width="${size.width}" height="${size.height * 0.90}">Loading...</iframe>""",
        shrinkWrap: false,
      ),
    );
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey openInBrowser = GlobalKey();

  void showTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool(SP.mapPageTutorial) == null) {
      initTargets();
      tutorialCoachMark = TutorialCoachMark(
          targets: targets,
          colorShadow: rPrimaryDarkLiteColor,
          textSkip: "SKIP",
          alignSkip: Alignment.bottomRight,
          paddingFocus: 10,
          hideSkip: true,
          opacityShadow: 0.8,
          onSkip: () {
            targets.clear();
            pref.setBool(SP.mapPageTutorial, true);
            return true;
          },
          onFinish: () {
            pref.setBool(SP.mapPageTutorial, true);
          })
        ..show(context: context);
    }
  }

  void initTargets() {
    targets.clear();
    targets.add(targetFocus("Click here to open this map in browser",
        Icons.share, openInBrowser, "openInBrowser",
        isTop: false));
  }
}
