import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/useful_links_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Presentation/Widgets/sticky_group_listview.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulLinksPage extends StatefulWidget {
  const UsefulLinksPage({Key? key}) : super(key: key);
  @override
  _UsefulLinksPageState createState() => _UsefulLinksPageState();
}

class _UsefulLinksPageState extends State<UsefulLinksPage> {
  late ScrapTableProvider _scrapTableProvider;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Useful Links Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Useful Links'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.arrow_circle_up),
      // ),
      body: StickyGroupedListView<UsefulLinksModel, String>(
        elements: _scrapTableProvider.usefulLinks.toList(),
        groupBy: (UsefulLinksModel element) => element.type!,
        itemComparator: (UsefulLinksModel e1, UsefulLinksModel e2) =>
            e1.type!.compareTo(e2.type!),
        groupSeparatorBuilder: (UsefulLinksModel element) => Container(
          color: Theme.of(context).primaryColor == rPrimaryMaterialColorLite
              ? rTextColor
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              element.type!,
              style: TextStyle(
                fontSize: 20,
                color:
                    Theme.of(context).primaryColor == rPrimaryMaterialColorLite
                        ? Colors.white
                        : rTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        itemBuilder: (context, UsefulLinksModel element) => ListTile(
          onTap: () {
            launchUrl(
              Uri.parse(element.url!),
              mode: LaunchMode.externalApplication,
            );
          },
          leading: ImageCus(completeUrl: element.image),
          title: Text(element.title ?? "N/A"),
          subtitle: Text(element.desc ?? "N/A"),
        ),
      ),
    );
  }
}
