import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewer extends StatelessWidget {
  const HtmlViewer({super.key, required this.data, required this.shrinkWrap});
  final String data;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      shrinkWrap: shrinkWrap,
      extensions: const [
        IframeHtmlExtension(),
        SvgHtmlExtension(),
        TableHtmlExtension(),
        VideoHtmlExtension(),
      ],
      onLinkTap: (url, attributes, element) => launchUrlString(url!),
    );
  }
}
