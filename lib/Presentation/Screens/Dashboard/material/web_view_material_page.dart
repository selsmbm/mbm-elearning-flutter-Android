import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewMaterialPage extends StatefulWidget {
  const WebViewMaterialPage({Key? key, required this.url, required this.title})
      : super(key: key);
  final String url;
  final String title;
  @override
  State<WebViewMaterialPage> createState() => _WebViewMaterialPageState();
}

class _WebViewMaterialPageState extends State<WebViewMaterialPage> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.url.contains("youtube.com") ||
              widget.url.contains("you.tube"))
            IconButton(
              onPressed: () {
                launch(widget.url);
              },
              icon: const Icon(Icons.open_in_new),
            ),
        ],
      ),
      body: SafeArea(
        child: Html(
          data: """
<iframe src="${widget.url}" width="${size.width}" height="${size.height * 0.88}">Loading...</iframe>""",
          customRenders: {
            iframeMatcher(): iframeRender(),
          },
        ),
      ),
    );
  }
}
