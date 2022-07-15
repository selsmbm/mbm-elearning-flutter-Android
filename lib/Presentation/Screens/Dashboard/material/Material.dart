import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/textfieldDeco.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/material_details_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

String? sem;
String? branch;

class MaterialsPage extends StatefulWidget {
  final String? sem;
  final String? branch;
  const MaterialsPage({Key? key, this.sem, this.branch}) : super(key: key);
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    sem = widget.sem;
    if (allBranchSemsData.contains(sem)) {
      branch = '';
    } else {
      branch = widget.branch;
    }
    tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    setCurrentScreenInGoogleAnalytics('material Page');
  }

  @override
  void dispose() {
    tabController.dispose();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'addMaterialPage');
        },
        icon: Icon(Icons.add),
        label: Text('Add material'),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Material',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: TabBar(
            onTap: (index) {
              setState(() {
                tabController.index = index;
              });
            },
            controller: tabController,
            unselectedLabelColor: Colors.grey,
            labelColor: rPrimaryColor,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 3.0),
              ),
            ),
            tabs: [
              for (var t in mttypes)
                Padding(
                  padding: tabPadding,
                  child: Text(
                    t.toUpperCase(),
                    style: tabTextStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: TabBarView(
            controller: tabController,
            children: [
              for (var t in mttypes)
                MtCard(
                  title: t,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class MtCard extends StatefulWidget {
  final String title;
  const MtCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MtCardState createState() => _MtCardState();
}

class _MtCardState extends State<MtCard> {
  int skip = 0;
  int limit = 15;
  bool showMt = false;
  List material = [];
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetMaterialApiBloc>(context).add(
      FetchGetMaterialApi(
        sem ?? '',
        branch ?? '',
        skip,
        limit,
        widget.title,
        '',
        '',
        'true',
        true,
      ),
    );
    itemPositionsListener.itemPositions.addListener(() {
      if (itemPositionsListener.itemPositions.value.last.index == skip + 14) {
        skip = skip + limit;
        BlocProvider.of<GetMaterialApiBloc>(context).add(
          FetchGetMaterialApi(
            '',
            '',
            skip,
            limit,
            '',
            '',
            '',
            'true',
            false,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMaterialApiBloc, GetMaterialApiState>(
      builder: (context, state) {
        if (state is GetMaterialApiIsSuccess) {
          if (skip == 0) {
            if (material.isNotEmpty) {
              material.clear();
            }
          }
          material.addAll(state.output);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: material.isEmpty
                ? const Center(
                    child: Text('No Data'),
                  )
                : ScrollablePositionedList.builder(
                    itemPositionsListener: itemPositionsListener,
                    itemCount: material.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                           showDialog(
                                context: context,
                                builder: (context) => MaterialDetailsPage(
                                  material: material[index],
                                  isMe: false,
                                ),
                              );
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            material[index]['mtname'],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
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
        } else {
          return Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }
}
