import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
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
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: true),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  final StreamController<WebViewButtonStatus?> showButtonStatus =
      StreamController<WebViewButtonStatus?>();
  final StreamController<int> isPageLoading = StreamController<int>();

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(),
          ElevatedButton(
            child: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              webViewController?.goBack();
            },
          ),
          ElevatedButton(
            child: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              webViewController?.goForward();
            },
          ),
          ElevatedButton(
            child: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              webViewController?.reload();
            },
          ),
          StreamBuilder<WebViewButtonStatus?>(
            stream: showButtonStatus.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == WebViewButtonStatus.yt) {
                  return ElevatedButton(
                    child:
                        const Icon(Icons.open_in_browser, color: Colors.white),
                    onPressed: () async {
                      var url = await webViewController?.getUrl();
                      if (url != null) {
                        launchUrl(url);
                      }
                    },
                  );
                } else if (snapshot.data == WebViewButtonStatus.dl) {
                  return ElevatedButton(
                    child: const Icon(Icons.download, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  );
                } else {
                  return SizedBox();
                }
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  if (url.toString().contains('youtube.com')) {
                    showButtonStatus.add(WebViewButtonStatus.yt);
                  } else if (url.toString().contains('/file/')) {
                    showButtonStatus.add(WebViewButtonStatus.dl);
                  } else {
                    showButtonStatus.add(null);
                  }
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  if (url.toString().contains('youtube.com')) {
                    showButtonStatus.add(WebViewButtonStatus.yt);
                  } else if (url.toString().contains('/file/')) {
                    showButtonStatus.add(WebViewButtonStatus.dl);
                  } else {
                    showButtonStatus.add(null);
                  }
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  isPageLoading.add(progress);
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  if (url.toString().contains('youtube.com')) {
                    showButtonStatus.add(WebViewButtonStatus.yt);
                  } else if (url.toString().contains('/file/')) {
                    showButtonStatus.add(WebViewButtonStatus.dl);
                  } else {
                    showButtonStatus.add(null);
                  }
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              StreamBuilder<int>(
                stream: isPageLoading.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      if (snapshot.data != 100) {
                        return LinearProgressIndicator(
                          value: snapshot.data! / 100.0,
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
