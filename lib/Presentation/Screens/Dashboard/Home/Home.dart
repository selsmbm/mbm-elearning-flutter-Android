
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/TextFielsContainer.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/Material.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? materialBranch;
  String? materialSem;
  late ScrapTableProvider _scrapTableProvider;
  late FirebaseMessaging messaging;
  
  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Home Page');
  }

  @override
  Widget build(BuildContext context) {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _scrapTableProvider.isGettingMaterialData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MBM E-Learning'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addMaterialPage');
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: kIsWeb ? 400 : double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: Image.asset(
                        'assets/lottie/concept.gif',
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
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          hintText: 'Globel Search',
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColor ==
                                    rPrimaryMaterialColorLite
                                ? rTextColor
                                : Colors.white,
                            fontSize: 16,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: rPrimaryLiteColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: rPrimaryLiteColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor ==
                                    rPrimaryMaterialColorLite
                                ? rTextColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    const Text(
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
                                value: subject,
                                child: Text(subject.toUpperCase())))
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
                                  child: Text(subject.toUpperCase()),
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
