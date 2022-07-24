import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({Key? key, required this.event}) : super(key: key);
  final EventsModel event;
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late ScrapTableProvider _scrapTableProvider;
  late EventsModel event;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    event = widget.event;
    setCurrentScreenInGoogleAnalytics('Event Details Page');
  }

  @override
  Widget build(BuildContext context) {
    Map org = jsonDecode(event.adminOrg!);
    DateTime startdate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(event.starttime!) * 1000);
    DateTime enddate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(event.endtime!) * 1000);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.share),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
                  String key = "${event.title}-${event.id}";
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
                    return SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            IconButton(
              onPressed: () {
                launch(event.website!);
              },
              icon: Icon(Icons.language),
            ),
            SizedBox(
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
                  event.title ?? "N/A",
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Text(
                  "${startdate.day}/${startdate.month}/${startdate.year} ${startdate.hour}:${startdate.minute} - ${enddate.day}/${enddate.month}/${enddate.year} ${enddate.hour}:${enddate.minute}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BigImageCus(
                  image: event.image,
                ),
                SizedBox(
                  height: 20,
                ),
                Linkify(
                  text: event.desc ?? "N/A",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  onOpen: (link) {
                    launch(link.url);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                if (org.isNotEmpty)
                  Text(
                    "Organizer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                if (org.isNotEmpty)
                  ListTile(
                    onTap: () {},
                    leading: ImageCus(image: org['image']),
                    title: Text(org['name'] ?? "N/A"),
                    subtitle:
                        org['tagline'] != null ? Text(org['tagline']!) : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
