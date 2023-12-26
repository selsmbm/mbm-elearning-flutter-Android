import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    this.event,
    required this.eventId,
  });
  final EventsModel? event;
  final int eventId;
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late ScrapTableProvider _scrapTableProvider;
  EventsModel? event;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    event = widget.event ?? _scrapTableProvider.getEventById(widget.eventId);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Event Details Page');
  }

  Map? org;
  DateTime? startdate;
  DateTime? enddate;

  @override
  Widget build(BuildContext context) {
    if (event != null) {
      org = jsonDecode(event!.adminOrg!);
      startdate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(event!.starttime!) * 1000);
      enddate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(event!.endtime!) * 1000);
    }
    return Scaffold(
      floatingActionButton: event != null && !kIsWeb
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait...'),
                    duration: Duration(seconds: 1),
                  ),
                );
                shareDynamicLink(
                  id: event!.id.toString(),
                  title: event!.title!,
                  purpose: DL.event,
                );
              },
              child: const Icon(Icons.share),
            )
          : null,
      bottomNavigationBar: event != null
          ? BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                if (!kIsWeb)  FutureBuilder<SharedPreferences>(
                      future: SharedPreferences.getInstance(),
                      builder:
                          (context, AsyncSnapshot<SharedPreferences> snapshot) {
                        String key = "E-${event!.id}";
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
                                "Unfollow",
                                style: TextStyle(
                                  color: rPrimaryColor,
                                ),
                              ),
                            );
                          } else {
                            return ElevatedButton(
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
                      launch(event!.website!);
                    },
                    icon: const Icon(Icons.language),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          : null,
      body: SafeArea(
        child: event != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event!.title ?? "N/A",
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        "${startdate!.day}/${startdate!.month}/${startdate!.year} ${startdate!.hour}:${startdate!.minute} - ${enddate!.day}/${enddate!.month}/${enddate!.year} ${enddate!.hour}:${enddate!.minute}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          bigImageShower(
                            context,
                            "$driveImageShowUrl${event!.image != null && event!.image != '' ? event!.image : defaultDriveImageShowUrl}",
                          );
                        },
                        child: BigImageCus(
                          image: event!.image,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Linkify(
                        text: event!.desc ?? "N/A",
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
                      if (org!.isNotEmpty)
                        const Text(
                          "Organizer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      if (org!.isNotEmpty)
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ExploreDetailsPage(
                                    exploreId: int.parse(org!['id']),
                                  );
                                },
                              ),
                            );
                          },
                          leading: ImageCus(image: org!['image']),
                          title: Text(org!['name'] ?? "N/A"),
                          subtitle: org!['tagline'] != null
                              ? Text(org!['tagline']!)
                              : null,
                        ),
                    ],
                  ),
                ),
              )
            : const Center(child: Text("This event is not available")),
      ),
    );
  }
}
