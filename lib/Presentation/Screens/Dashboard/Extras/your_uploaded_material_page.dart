import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/material_details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class YourMaterialPage extends StatefulWidget {
  const YourMaterialPage({Key? key}) : super(key: key);
  @override
  _YourMaterialPageState createState() => _YourMaterialPageState();
}

class _YourMaterialPageState extends State<YourMaterialPage> {
  User? user = FirebaseAuth.instance.currentUser;
  int skip = 0;
  int limit = 15;
  bool showMt = false;
  late List completeMaterial;
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    completeMaterial = [];
    setCurrentScreenInGoogleAnalytics('your uploaded material Page');
    BlocProvider.of<GetMaterialApiBloc>(context).add(
      FetchGetMaterialApi(
        '',
        '',
        null,
        null,
        '',
        '',
        user!.uid,
        '',
        true,
      ),
    );
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(() {});
    if (completeMaterial.isNotEmpty) {
      completeMaterial.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'addMaterialPage');
        },
        icon: Icon(Icons.add),
        label: Text('Add material'),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Material'),
      ),
      body: SafeArea(
        child: BlocBuilder<GetMaterialApiBloc, GetMaterialApiState>(
          builder: (context, state) {
            if (state is GetMaterialApiIsSuccess) {
              if (skip == 0) {
                if (completeMaterial.isNotEmpty) {
                  completeMaterial.clear();
                }
              }
              completeMaterial.addAll(state.output);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: completeMaterial.isEmpty
                    ? const Center(
                        child: Text(
                          'Nothing here\nUpload some material',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ScrollablePositionedList.builder(
                        itemPositionsListener: itemPositionsListener,
                        itemCount: completeMaterial.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) => MaterialDetailsPage(
                                  material: completeMaterial[index],
                                  isMe: true,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: rPrimaryLiteColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Icon(
                                        typeIcon[completeMaterial[index]
                                            ['mttype']],
                                        color: rPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          completeMaterial[index]['mtname'],
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          completeMaterial[index]['mtsub']
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      localDbConnect.addBookMarkMt(
                                        BookMarkMt(
                                          title: completeMaterial[index]
                                              ['mtname'],
                                          url: completeMaterial[index]['mturl'],
                                          subject: completeMaterial[index]
                                              ['mtsub'],
                                          type: completeMaterial[index]
                                              ['mttype'],
                                          sem: completeMaterial[index]['mtsem'],
                                          branch: completeMaterial[index]
                                              ['branch'],
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Material add to bookmark',
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, 'bookmark');
                                                },
                                                child: const Text(
                                                  'check',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.bookmark_border_outlined,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            } else if (state is GetMaterialApiIsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetMaterialApiIsFailed) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
