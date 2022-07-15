import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/TextFielsContainer.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/Material.dart';
import 'package:mbm_elearning/Presentation/Widgets/carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? materialBranch;
  String? materialSem;

  // getHomePopupCusAdsDataRequest() async {
  //   List outData = [];
  //   try {
  //     http.Response response = await http.get(Uri.parse(
  //         'https://script.google.com/macros/s/AKfycbwydcWE04dLME_lqt9Bx347XK_589yRkVsQuk9xG6h3SOqH1xXIHYcNVZfeXIi6iM25/exec'));
  //     if (response.statusCode == 200) {
  //       for (var d in json.decode(response.body)) {
  //         if (d['image'] != 'imageUrl') {
  //           print(d);
  //           if (d['showstatus'] == true) {
  //             showDialog(
  //               context: context,
  //               builder: (context) => Dialog(
  //                 child: SizedBox(
  //                   height: 300,
  //                   width: 300,
  //                   child: Column(
  //                     children: [
  //                       Expanded(
  //                           child: TextButton(
  //                               onPressed: () {
  //                                 launch(d['url']);
  //                               },
  //                               child: Image.network(
  //                                 d['image'],
  //                               ))),
  //                       ElevatedButton(
  //                         child: const Text('Close'),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //         }
  //       }
  //     }
  //   } on Exception catch (e) {
  //     print(e);
  //     print('network error');
  //   }
  // }

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    // getHomePopupCusAdsDataRequest();
    setCurrentScreenInGoogleAnalytics('Home Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('MBM E-Learning'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addMaterialPage');
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 240,
                    width: 240,
                    child: LottieBuilder.asset(
                      'assets/lottie/concept.json',
                      width: 240,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Select respective fields",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      onTap: () {
                        Navigator.pushNamed(context, 'search');
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        hintText: 'Globel Search',
                        hintStyle: TextStyle(
                          color: rTextColor,
                          fontSize: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: rPrimaryLiteColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: rPrimaryLiteColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: rTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    'or',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  TextFieldContainer(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Material Sem',
                      ),
                      value: materialSem,
                      onChanged: (value) async {
                        setState(() {
                          materialSem = value.toString();
                        });
                        if (allBranchSemsData.contains(materialSem)) {
                          goToMaterialPage(context);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text('Now select your branch'),
                          ));
                        }
                      },
                      items: semsData
                          .map((subject) => DropdownMenuItem(
                              value: subject, child: Text("$subject")))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  if (materialSem != null &&
                      !allBranchSemsData.contains(materialSem))
                    TextFieldContainer(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Material Branch',
                        ),
                        value: materialBranch,
                        onChanged: (value) {
                          setState(() {
                            materialBranch = value.toString();
                          });
                          if (materialSem != null) {
                            goToMaterialPage(context);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text('Now select your sem'),
                            ));
                          }
                        },
                        items: branches
                            .map(
                              (subject) => DropdownMenuItem(
                                value: subject,
                                child: Text("${subject.toUpperCase()}"),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  const SizedBox(
                    height: 10,
                  ),
                  // CarouselAds(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goToMaterialPage(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => GetMaterialApiBloc(
                      GetMaterialRepo(),
                    ),
                    child: MaterialsPage(
                      sem: materialSem ?? '',
                      branch: materialBranch ?? '',
                    ),
                  ))).then((value) {
        materialBranch = null;
        materialSem = null;
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text('No internet'),
      ));
      materialBranch = null;
      materialSem = null;
      setState(() {});
    }
  }
}
