import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int skip = 0;
  int limit = 10;
  bool showMt = false;
  List material = [];

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('search Page');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 5);
    var tabTextStyle = const TextStyle(
      color: rTextColor,
      fontSize: 12,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                  child: TextField(
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      material.clear();
                    });
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    BlocProvider.of<GetMaterialApiBloc>(context).add(
                      FetchGetMaterialApi(
                        '',
                        '',
                        skip,
                        limit,
                        '',
                        value,
                        '',
                        'true',
                      ),
                    );
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              )),
              const SizedBox(width: 5),
              const Icon(
                Icons.search,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<GetMaterialApiBloc, GetMaterialApiState>(
          builder: (context, state) {
            if (state is GetMaterialApiIsSuccess) {
              if (material.isNotEmpty) {
                material.clear();
              }
              material.addAll(state.output);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: material.isEmpty
                    ? const Center(
                        child: Text('No Data'),
                      )
                    : ListView.builder(
                        itemCount: material.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              launch(material[index]['mturl']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xff0015CE),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              material[index]['mtname'],
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
                                              material[index]['mtsub']
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${material[index]['mtsem']} | ${allBranchSemsData.contains(material[index]['mtsem']) ? "All" : material[index]['branch']} | ${material[index]['mttype']}"
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
                                              title: material[index]['mtname'],
                                              url: material[index]['mturl'],
                                              subject: material[index]['mtsub'],
                                              type: material[index]['mttype'],
                                              sem: material[index]['mtsem'],
                                              branch: material[index]['branch'],
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.bookmark_border_outlined,
                                          color: Color(0xff0015CE),
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
