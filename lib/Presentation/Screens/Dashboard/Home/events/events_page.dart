import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/event_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late ScrapTableProvider _scrapTableProvider;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Events Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Events'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.arrow_circle_up),
      // ),
      body: ListView.builder(
        itemCount: _scrapTableProvider.events.length,
        itemBuilder: (context, index) {
          EventsModel event = _scrapTableProvider.events[index];
          String org = json.decode(event.adminOrg!)['name'];
          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(event.starttime!) * 1000);
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventDetailsPage(event: event);
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
    );
  }
}
