import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/event_details_page.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/utilities/mbm_map.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreDetailsPage extends StatefulWidget {
  const ExploreDetailsPage({Key? key, this.explore, required this.exploreId})
      : super(key: key);
  final ExploreModel? explore;
  final int exploreId;
  @override
  _ExploreDetailsPageState createState() => _ExploreDetailsPageState();
}

class _ExploreDetailsPageState extends State<ExploreDetailsPage> {
  late ScrapTableProvider _scrapTableProvider;
  ExploreModel? explore;

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Explore Details Page');
  }

  @override
  void didChangeDependencies() {
    showTutorial();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    if (widget.explore != null) {
      explore = widget.explore!;
    } else {
      explore = _scrapTableProvider.getExploreById(widget.exploreId);
    }
    if (explore != null) {
      List admins = jsonDecode(explore!.adminsMap!);
      List<EventsModel> events = _scrapTableProvider.events
          .where((EventsModel element) =>
              element.adminOrgIds!.contains(explore!.id.toString())).toSet()
          .toList();
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          key: shareButtonKey,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please wait...'),
                duration: Duration(seconds: 1),
              ),
            );
            shareDynamicLink(
              id: explore!.id.toString(),
              title: explore!.title!,
              purpose: DL.explore,
            );
          },
          child: const Icon(Icons.share),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (explore!.map != null && explore!.map != "")
                ElevatedButton(
                  key: mapShareKey,
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MBMMap(
                        url: explore!.map,
                        title: explore!.title!,
                      );
                    }));
                  },
                  child: const Text(
                    "Map",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              if (!kIsWeb)
                FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder:
                        (context, AsyncSnapshot<SharedPreferences> snapshot) {
                      String key = "O-${explore!.id}";
                      if (snapshot.hasData) {
                        if (snapshot.data!.getBool(key) ?? false) {
                          return OutlinedButton(
                            onPressed: () async {
                              await FirebaseMessaging.instance
                                  .unsubscribeFromTopic(key);
                              await snapshot.data!.setBool(key, false);
                              setState(() {});
                            },
                            child: const Text(
                              "unFollow",
                              style: TextStyle(
                                color: rPrimaryColor,
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            key: followButtonKey,
                            onPressed: () async {
                              await FirebaseMessaging.instance
                                  .subscribeToTopic(key);
                              await snapshot.data!.setBool(key, true);
                              setState(() {});
                            },
                            child: const Text(
                              "Follow",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              IconButton(
                onPressed: () {
                  launch(explore!.website!);
                },
                icon: const Icon(Icons.language),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    explore!.title ?? "N/A",
                    style: const TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    explore!.tagline ?? "N/A",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: rPrimaryLiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: rPrimaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            explore!.type!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: rPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      bigImageShower(
                        context,
                        "$driveImageShowUrl${explore!.image != null && explore!.image != '' ? explore!.image : defaultDriveImageShowUrl}",
                      );
                    },
                    child: BigImageCus(
                      image: explore!.image,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Linkify(
                    text: explore!.desc ?? "N/A",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    onOpen: (link) {
                      launch(link.url);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  if (events.isNotEmpty)
                    const Text(
                      "Events",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (events.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        EventsModel event = events[index];
                        String org = json.decode(event.adminOrg!)['name'];
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(event.starttime!) * 1000);
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EventDetailsPage(
                                      event: event, eventId: event.id!);
                                },
                              ),
                            );
                          },
                          leading: ImageCus(image: event.image),
                          title: Text(event.title ?? "N/A"),
                          subtitle: Text(
                              "$org | Start from: ${date.day}-${date.month}-${date.year}"),
                        );
                      },
                    ),
                  if (admins.isNotEmpty)
                    const Text(
                      "People",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (admins.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: admins.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading:
                              UserImageByName(name: admins[index]['username']),
                          title: Text(admins[index]['username']),
                          subtitle: Text(admins[index]['Position']),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text("This explore is not available"),
        ),
      );
    }
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey shareButtonKey = GlobalKey();
  GlobalKey mapShareKey = GlobalKey();
  GlobalKey followButtonKey = GlobalKey();

  void showTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool(SP.exploreDetailsPageTutorial) == null) {
      initTargets();
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: rPrimaryDarkLiteColor,
          textSkip: "SKIP",
          paddingFocus: 10,
          opacityShadow: 0.8, onSkip: () {
        targets.clear();
        pref.setBool(SP.exploreDetailsPageTutorial, true);
      }, onFinish: () {
        pref.setBool(SP.exploreDetailsPageTutorial, true);
      })
        ..show();
    }
  }

  void initTargets() {
    targets.clear();
    targets.add(targetFocus("Share this explore with your friends", Icons.share,
        shareButtonKey, "Share"));
    if (explore!.map != null && explore!.map != "") {
      targets.add(targetFocus(
          "Visit the map of this explore", Icons.map, mapShareKey, "map"));
    }
    targets.add(targetFocus("Follow this explore to get notifications",
        Icons.wifi, followButtonKey, "follow"));
  }
}
