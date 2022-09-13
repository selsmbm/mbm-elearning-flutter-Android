import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewMaterialPage extends StatefulWidget {
  const WebViewMaterialPage({Key? key, required this.url, required this.title})
      : super(key: key);
  final String url;
  final String title;
  @override
  State<WebViewMaterialPage> createState() => _WebViewMaterialPageState();
}

class _WebViewMaterialPageState extends State<WebViewMaterialPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final StreamController<WebViewButtonStatus?> showButtonStatus =
      StreamController<WebViewButtonStatus?>();
  final StreamController<int> isPageLoading = StreamController<int>();
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics(
        "Material open page online ${widget.title}");
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    showTutorial();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Menu(_controller.future, null),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: NavigationControls(_controller.future,
            showButtonStatus: showButtonStatus),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: WebView(
              initialUrl: 'https://mbmec.weebly.com/civil2.html',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                isPageLoading.add(progress);
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              onPageStarted: (String url) {
                if (url.contains('youtube.com')) {
                  showButtonStatus.add(WebViewButtonStatus.yt);
                } else if (url.contains('/file/')) {
                  showButtonStatus.add(WebViewButtonStatus.dl);
                } else {
                  showButtonStatus.add(null);
                }
              },
              onPageFinished: (url) async {
                if (url.contains('youtube.com')) {
                  showButtonStatus.add(WebViewButtonStatus.yt);
                } else if (url.contains('/file/')) {
                  showButtonStatus.add(WebViewButtonStatus.dl);
                } else {
                  showButtonStatus.add(null);
                }
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
          ),
        ],
      ),
    );
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey openInBrowser = GlobalKey();

  void showTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool(SP.mapPageTutorial) == null) {
      initTargets();
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: rPrimaryDarkLiteColor,
          textSkip: "SKIP",
          alignSkip: Alignment.bottomRight,
          paddingFocus: 10,
          hideSkip: true,
          opacityShadow: 0.8, onSkip: () {
        targets.clear();
        pref.setBool(SP.mapPageTutorial, true);
      }, onFinish: () {
        pref.setBool(SP.mapPageTutorial, true);
      })
        ..show();
    }
  }

  void initTargets() {
    targets.clear();
    targets.add(targetFocus("Click here to open this map in browser",
        Icons.share, openInBrowser, "openInBrowser",
        isTop: false));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

enum MenuOptions {
  clearCookies,
  clearCache,
}

class Menu extends StatelessWidget {
  Menu(this.controller, CookieManager? cookieManager, {Key? key})
      : cookieManager = cookieManager ?? CookieManager(),
        super(key: key);

  final Future<WebViewController> controller;
  late final CookieManager cookieManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          key: const ValueKey<String>('ShowPopupMenu'),
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Clear cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onClearCache(
      WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cache cleared.'),
    ));
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture,
      {Key? key, required this.showButtonStatus})
      : assert(_webViewControllerFuture != null),
        super(key: key);

  final Future<WebViewController> _webViewControllerFuture;
  final StreamController<WebViewButtonStatus?> showButtonStatus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No back history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No forward history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
            StreamBuilder<WebViewButtonStatus?>(
              stream: showButtonStatus.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == WebViewButtonStatus.yt) {
                    return IconButton(
                      icon: const Icon(Icons.open_in_browser),
                      onPressed: () async {
                        var url = await controller!.currentUrl();
                        if (url != null) {
                          launchUrl(Uri.parse(url));
                        }
                      },
                    );
                  } else if (snapshot.data == WebViewButtonStatus.dl) {
                    return IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
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
        );
      },
    );
  }
}
