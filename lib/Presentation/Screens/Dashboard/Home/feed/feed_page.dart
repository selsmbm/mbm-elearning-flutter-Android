import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/blog_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  late ScrapTableProvider _scrapTableProvider;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Feeds Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Feeds'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.arrow_circle_up),
      // ),
      body: ListView.builder(
        itemCount: _scrapTableProvider.events.length,
        itemBuilder: (context, index) {
          BlogModel event = _scrapTableProvider.blogPosts[index];
          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
              int.parse(event.posttime!) * 1000);
          return ListTile(
            leading: const CircleAvatar(
              radius: 23,
              backgroundColor: rPrimaryLiteColor,
              child: Icon(
                Icons.feed,
                color: rPrimaryColor,
              ),
            ),
            title: Text(event.title ?? "N/A"),
            subtitle:
                Text("${date.day}-${date.month}-${date.year} | ${event.org}"),
          );
        },
      ),
    );
  }
}
