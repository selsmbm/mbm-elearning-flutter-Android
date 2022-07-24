import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreDetailsPage extends StatefulWidget {
  const ExploreDetailsPage({Key? key, required this.explore}) : super(key: key);
  final ExploreModel explore;
  @override
  _ExploreDetailsPageState createState() => _ExploreDetailsPageState();
}

class _ExploreDetailsPageState extends State<ExploreDetailsPage> {
  late ScrapTableProvider _scrapTableProvider;
  late ExploreModel explore;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    explore = widget.explore;
    setCurrentScreenInGoogleAnalytics('Explore Details Page');
  }

  @override
  Widget build(BuildContext context) {
    List admins = jsonDecode(explore.adminsMap!);
    List<EventsModel> events = _scrapTableProvider.events
        .where((EventsModel element) =>
            element.adminOrgIds!.contains(explore.id.toString()))
        .toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.share),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Follow",
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
            IconButton(
              onPressed: () {
                launch(explore.website!);
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
                  explore.title ?? "N/A",
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Text(
                  explore.tagline ?? "N/A",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
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
                        Icon(
                          Icons.star,
                          color: rPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          explore.type!,
                          style: TextStyle(
                            fontSize: 16,
                            color: rPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BigImageCus(
                  image: explore.image,
                ),
                SizedBox(
                  height: 20,
                ),
                Linkify(
                  text: explore.desc ?? "N/A",
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
                if (events.isNotEmpty)
                  Text(
                    "Events",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                if (events.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      EventsModel event = events[index];
                      String org = json.decode(event.adminOrg!)['name'];
                      DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(event.starttime!) * 1000);
                      return ListTile(
                        leading: ImageCus(image: event.image),
                        title: Text(event.title ?? "N/A"),
                        subtitle: Text(
                            "$org | Start from: ${date.day}-${date.month}-${date.year}"),
                      );
                    },
                  ),
                if (admins.isNotEmpty)
                  Text(
                    "People",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                if (admins.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
  }
}
