// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html_all/flutter_html_all.dart';
// import 'package:mbm_elearning/Data/googleAnalytics.dart';
// import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
// import 'package:mbm_elearning/Presentation/Constants/constants.dart';
// import 'package:mbm_elearning/Presentation/Constants/utills.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// // ignore: depend_on_referenced_packages
// // import 'package:flutter_html_iframe/shims/dart_ui.dart' as ui;
// // ignore: avoid_web_libraries_in_flutter
// // import 'dart:html' as html;

// class WebViewMaterialPage extends StatefulWidget {
//   const WebViewMaterialPage({Key? key, required this.url, required this.title})
//       : super(key: key);
//   final String url;
//   final String title;
//   @override
//   State<WebViewMaterialPage> createState() => _WebViewMaterialPageState();
// }

// class _WebViewMaterialPageState extends State<WebViewMaterialPage> {
//   final GlobalKey webViewKey = GlobalKey();
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   final StreamController<WebViewButtonStatus?> showButtonStatus =
//       StreamController<WebViewButtonStatus?>();
//   final StreamController<int> isPageLoading = StreamController<int>();
//   @override
//   void initState() {
//     setCurrentScreenInGoogleAnalytics(
//         "Material open page online ${widget.title}");
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     showTutorial();
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           Menu(_controller.future, null),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: NavigationControls(_controller.future,
//             showButtonStatus: showButtonStatus),
//       ),
//       body: SafeArea(
//         child: Html(
//           data: """
// <iframe src="${widget.url}" width="${size.width}" height="${size.height * 0.88}">Loading...</iframe>""",
//           customRenders: {
//             iframeMatcher(): //kIsWeb ? iframeRenderWeb() :
//                 iframeRenderMobile(),
//           },
//         ),
//       ),
//     );
//   }

//   CustomRender iframeRenderMobile({NavigationDelegate? navigationDelegate}) =>
//       CustomRender.widget(widget: (context, buildChildren) {
//         final sandboxMode = context.tree.element?.attributes["sandbox"];
//         final UniqueKey key = UniqueKey();
//         final givenWidth =
//             double.tryParse(context.tree.element?.attributes['width'] ?? "");
//         final givenHeight =
//             double.tryParse(context.tree.element?.attributes['height'] ?? "");
//         return SizedBox(
//           width: givenWidth ?? (givenHeight ?? 150) * 2,
//           height: givenHeight ?? (givenWidth ?? 300) / 2,
//           child: ContainerSpan(
//             style: context.style,
//             newContext: context,
//             child: Column(
//               children: [
//                 StreamBuilder<int>(
//                   stream: isPageLoading.stream,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if (snapshot.data != null) {
//                         if (snapshot.data != 100) {
//                           return LinearProgressIndicator(
//                             value: snapshot.data! / 100.0,
//                           );
//                         } else {
//                           return const SizedBox();
//                         }
//                       } else {
//                         return const SizedBox();
//                       }
//                     } else {
//                       return const SizedBox();
//                     }
//                   },
//                 ),
//                 Expanded(
//                   child: WebView(
//                     initialUrl: context.tree.element?.attributes['src'],
//                     key: key,
//                     javascriptMode:
//                         sandboxMode == null || sandboxMode == "allow-scripts"
//                             ? JavascriptMode.unrestricted
//                             : JavascriptMode.disabled,
//                     navigationDelegate: navigationDelegate,
//                     onWebViewCreated: (WebViewController webViewController) {
//                       _controller.complete(webViewController);
//                     },
//                     onProgress: (int progress) {
//                       isPageLoading.add(progress);
//                     },
//                     onPageStarted: (String url) {
//                       if (url.contains('youtube.com')) {
//                         showButtonStatus.add(WebViewButtonStatus.yt);
//                       } else if (url.contains('/file/')) {
//                         showButtonStatus.add(WebViewButtonStatus.dl);
//                       } else {
//                         showButtonStatus.add(null);
//                       }
//                     },
//                     onPageFinished: (url) async {
//                       if (url.contains('youtube.com')) {
//                         showButtonStatus.add(WebViewButtonStatus.yt);
//                       } else if (url.contains('/file/')) {
//                         showButtonStatus.add(WebViewButtonStatus.dl);
//                       } else {
//                         showButtonStatus.add(null);
//                       }
//                     },
//                     gestureNavigationEnabled: true,
//                     backgroundColor: const Color(0x00000000),
//                     gestureRecognizers: {
//                       Factory<VerticalDragGestureRecognizer>(
//                           () => VerticalDragGestureRecognizer())
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });

// // CustomRender iframeRenderWeb({NavigationDelegate? navigationDelegate}) =>
// //     CustomRender.widget(
// //       widget: (context, buildChildren) {
// //         final givenWidth =
// //             double.tryParse(context.tree.element?.attributes['width'] ?? "");
// //         final givenHeight =
// //             double.tryParse(context.tree.element?.attributes['height'] ?? "");
// //         final html.IFrameElement iframe = html.IFrameElement()
// //           ..width = (givenWidth ?? (givenHeight ?? 150) * 2).toString()
// //           ..height = (givenHeight ?? (givenWidth ?? 300) / 2).toString()
// //           ..src = context.tree.element?.attributes['src']
// //           ..style.border = 'none';
// //         final String createdViewId = getRandString(10);
// //         ui.platformViewRegistry
// //             .registerViewFactory(createdViewId, (int viewId) => iframe);
// //         return Container(
// //           width: double.tryParse(
// //                   context.tree.element?.attributes['width'] ?? "") ??
// //               (double.tryParse(
// //                           context.tree.element?.attributes['height'] ?? "") ??
// //                       150) *
// //                   2,
// //           height: double.tryParse(
// //                   context.tree.element?.attributes['height'] ?? "") ??
// //               (double.tryParse(
// //                           context.tree.element?.attributes['width'] ?? "") ??
// //                       300) /
// //                   2,
// //           child: ContainerSpan(
// //             style: context.style,
// //             newContext: context,
// //             child: Directionality(
// //               textDirection: TextDirection.ltr,
// //               child: HtmlElementView(
// //                 viewType: createdViewId,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );

// // String getRandString(int len) {
// //   var random = Random.secure();
// //   var values = List<int>.generate(len, (i) => random.nextInt(255));
// //   return base64UrlEncode(values);
// // }

//   late TutorialCoachMark tutorialCoachMark;
//   List<TargetFocus> targets = <TargetFocus>[];

//   GlobalKey openInBrowser = GlobalKey();

//   void showTutorial() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     if (pref.getBool(SP.mapPageTutorial) == null) {
//       initTargets();
//       tutorialCoachMark = TutorialCoachMark(context,
//           targets: targets,
//           colorShadow: rPrimaryDarkLiteColor,
//           textSkip: "SKIP",
//           alignSkip: Alignment.bottomRight,
//           paddingFocus: 10,
//           hideSkip: true,
//           opacityShadow: 0.8, onSkip: () {
//         targets.clear();
//         pref.setBool(SP.mapPageTutorial, true);
//       }, onFinish: () {
//         pref.setBool(SP.mapPageTutorial, true);
//       })
//         ..show();
//     }
//   }

//   void initTargets() {
//     targets.clear();
//     targets.add(targetFocus("Click here to open this map in browser",
//         Icons.share, openInBrowser, "openInBrowser",
//         isTop: false));
//   }
// }

// enum MenuOptions {
//   clearCookies,
//   clearCache,
// }

// class Menu extends StatelessWidget {
//   Menu(this.controller, CookieManager? cookieManager, {Key? key})
//       : cookieManager = cookieManager ?? CookieManager(),
//         super(key: key);

//   final Future<WebViewController> controller;
//   late final CookieManager cookieManager;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: controller,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         return PopupMenuButton<MenuOptions>(
//           key: const ValueKey<String>('ShowPopupMenu'),
//           onSelected: (MenuOptions value) {
//             switch (value) {
//               case MenuOptions.clearCookies:
//                 _onClearCookies(context);
//                 break;
//               case MenuOptions.clearCache:
//                 _onClearCache(controller.data!, context);
//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCache,
//               child: Text('Clear cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCookies,
//               child: Text('Clear cookies'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _onClearCache(
//       WebViewController controller, BuildContext context) async {
//     await controller.clearCache();
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       content: Text('Cache cleared.'),
//     ));
//   }

//   Future<void> _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture,
//       {Key? key, required this.showButtonStatus})
//       : assert(_webViewControllerFuture != null),
//         super(key: key);

//   final Future<WebViewController> _webViewControllerFuture;
//   final StreamController<WebViewButtonStatus?> showButtonStatus;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController? controller = snapshot.data;
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             SizedBox(),
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                       if (await controller!.canGoBack()) {
//                         await controller.goBack();
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('No back history item')),
//                         );
//                         return;
//                       }
//                     },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                       if (await controller!.canGoForward()) {
//                         await controller.goForward();
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text('No forward history item')),
//                         );
//                         return;
//                       }
//                     },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                       controller!.reload();
//                     },
//             ),
//             StreamBuilder<WebViewButtonStatus?>(
//               stream: showButtonStatus.stream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data == WebViewButtonStatus.yt) {
//                     return IconButton(
//                       icon: const Icon(Icons.open_in_browser),
//                       onPressed: () async {
//                         var url = await controller!.currentUrl();
//                         if (url != null) {
//                           launchUrl(Uri.parse(url));
//                         }
//                       },
//                     );
//                   } else if (snapshot.data == WebViewButtonStatus.dl) {
//                     return IconButton(
//                       icon: const Icon(Icons.download),
//                       onPressed: () {},
//                     );
//                   } else {
//                     return SizedBox();
//                   }
//                 } else {
//                   return SizedBox();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
