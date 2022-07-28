import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:url_launcher/url_launcher.dart';

class MBMMap extends StatefulWidget {
  const MBMMap({Key? key}) : super(key: key);

  @override
  State<MBMMap> createState() => _MBMMapState();
}

class _MBMMapState extends State<MBMMap> {
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("MBM Map");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('MBM campus'),
        actions: [
          IconButton(
            onPressed: () {
              launch(
                  'https://www.google.com/maps/d/u/0/viewer?mid=1_Wg8w4EujrRyn9PHpoZdT1pvy73Pwvc&ll=26.264812241713493%2C73.03188249999998&z=15');
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Html(
        data: """
<iframe src="https://www.google.com/maps/d/embed?mid=1_Wg8w4EujrRyn9PHpoZdT1pvy73Pwvc&ehbc=2E312F&z=15" width="${size.width}" height="${size.height * 0.90}">Loading...</iframe>""",
      ),
    );
  }
}
