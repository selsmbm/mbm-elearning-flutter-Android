import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_details_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../events/event_details_page.dart';

class FeedDetailsPage extends StatefulWidget {
  const FeedDetailsPage({Key? key, this.feed, required this.feedId})
      : super(key: key);
  final BlogModel? feed;
  final int feedId;
  @override
  _FeedDetailsPageState createState() => _FeedDetailsPageState();
}

class _FeedDetailsPageState extends State<FeedDetailsPage> {
  late ScrapTableProvider _scrapTableProvider;
  BlogModel? feed;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    if (widget.feed != null) {
      feed = widget.feed!;
    } else {
      feed = _scrapTableProvider.getBlogPostById(widget.feedId);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Feed Details Page');
  }

  @override
  Widget build(BuildContext context) {
    if (feed == null) {
      return const Scaffold(
        body: Center(
          child: Text("This feed is not available"),
        ),
      );
    } else {
      DateTime posttime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(feed!.posttime!) * 1000);
      return ModalProgressHUD(
        inAsyncCall: _scrapTableProvider.isGettingData,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please wait...'),
                  duration: Duration(seconds: 1),
                ),
              );
              shareDynamicLink(
                id: feed!.id.toString(),
                title: feed!.title!,
                purpose: DL.feeds,
              );
            },
            child: Icon(Icons.share),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (feed!.url != "")
                  IconButton(
                    onPressed: () {
                      launch(feed!.url!);
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
                      feed!.title ?? "N/A",
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      "By ${feed!.uploadedByUser}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Row(
                      children: [
                        if (feed!.org != "")
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ExploreDetailsPage(
                                        exploreId: int.parse(feed!.orgid!));
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "${feed!.org}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        if (feed!.event != "")
                          const Text(
                            " | ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        if (feed!.event != "")
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EventDetailsPage(
                                      eventId: int.parse(feed!.eventid!),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "${feed!.event}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      "${posttime.day}/${posttime.month}/${posttime.year} ${posttime.hour}:${posttime.minute}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Html(
                      shrinkWrap: true,
                      data: feed!.description ?? "N/A",
                      onLinkTap: (url, ctx, attributes, element) =>
                          launch(url!),
                      onImageTap: (url, ctx, attributes, element) =>
                          bigImageShower(
                        context,
                        url!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
