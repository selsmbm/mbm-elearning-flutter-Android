import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/events/event_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late ScrapTableProvider _scrapTableProvider;
  bool isCalender = false;

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
    List<EventsModel> events = _scrapTableProvider.events;
    events.sort((a, b) {
      return b.starttime!.compareTo(a.starttime!);
    });
    return ModalProgressHUD(
      inAsyncCall: _scrapTableProvider.isGettingEventsData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Events'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       // isCalender = !isCalender;
        //       // if (isCalender) {
        //       // events =
        //       print(_scrapTableProvider.events.where((element) {
        //         DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
        //             int.parse(element.starttime!));
        //         print(startTime);
        //         DateTime now = DateTime(2022, 8, 4);
        //         return startTime.year == now.year &&
        //             startTime.month == now.month &&
        //             startTime.day == now.day;
        //       }).toList());
        //       // } else {
        //       //   events = _scrapTableProvider.events;
        //       // }
        //     });
        //   },
        //   child: const Icon(Icons.calendar_month),
        // ),
        body: Column(
          children: [
            // if (isCalender)
            //   CalendarTimeline(
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(DateTime.now().year - 1, 1, 1),
            //     lastDate: DateTime(DateTime.now().year + 1, 11, 20),
            //     onDateSelected: (date) {
            //       // setState(() {
            //       events = _scrapTableProvider.events.where((element) {
            //         DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
            //             int.parse(element.starttime!) * 1000);
            //         print(startTime);
            //         DateTime now = date;
            //         return startTime.month == now.month &&
            //             startTime.day == now.day;
            //       }).toList();
            //       // });
            //     },
            //     leftMargin: 20,
            //     monthColor: Colors.blueGrey,
            //     dayColor: Colors.teal[200],
            //     activeDayColor: Colors.white,
            //     activeBackgroundDayColor: Colors.redAccent[100],
            //     dotsColor: Color(0xFF333A47),
            //     selectableDayPredicate: (date) => date.day != 23,
            //   ),
            // if (isCalender)
            //   const SizedBox(
            //     height: 10,
            //   ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _scrapTableProvider.updateScrapEvents(),
                child: ListView.builder(
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
                      leading: GestureDetector(
                          onTap: () {
                            bigImageShower(
                              context,
                              "$driveImageShowUrl${event.image != null && event.image != '' ? event.image : defaultDriveImageShowUrl}",
                            );
                          },
                          child: ImageCus(image: event.image)),
                      title: Text(event.title ?? "N/A"),
                      subtitle: Text(
                          "$org | Start from: ${date.day}-${date.month}-${date.year}"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
