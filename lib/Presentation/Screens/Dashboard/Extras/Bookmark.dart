import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Home/Home.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  List<Map<String, dynamic>?> totalMaterial = [];

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text(
          'Bookmark',
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
            labelColor: Colors.white,
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
                    t,
                    style: tabTextStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: localDbConnect.getBookMarkMt(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                totalMaterial.addAll(snapshot.data);
                return SafeArea(
                  child: Center(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        for (var t in mttypes)
                          mtCard(
                            totalMaterial,
                            t,
                          )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'No data available',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  List material = [];
  final List _materialFilteredList = [];
  setData(totalMaterial, title) {
    material = totalMaterial
        .where(
            (element) => element['type'].toLowerCase() == title.toLowerCase())
        .toList();
  }

  mtCard(
    totalMaterial,
    title,
  ) {
    setData(totalMaterial, title);
    return Column(
      children: [
        // SizedBox(
        //   height: 60,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //     child: TextField(
        //         onChanged: (value) {
        //           if (value == null || value == '') {
        //             setState(() {
        //               _materialFilteredList.clear();
        //             });
        //           }
        //         },
        //         onSubmitted: (value) {
        //           if (value != null || value != '') {
        //             setState(() {
        //               _materialFilteredList = material
        //                   .where((element) => element['title'].contains(
        //                       new RegExp(value, caseSensitive: false)))
        //                   .toList();
        //             });
        //           } else {
        //             setState(() {
        //               _materialFilteredList.clear();
        //             });
        //           }
        //         },
        //         decoration: textFieldDeco),
        //   ),
        // ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: material.isEmpty
                  ? const Center(
                      child: Text('No Data'),
                    )
                  : materialList(
                      _materialFilteredList.isEmpty
                          ? material
                          : _materialFilteredList,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  materialList(material) {
    return ListView.builder(
      itemCount: material.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            launch(material[index]['url']);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              material[index]['title'],
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
                            'Subject: ${material[index]['subject'].toUpperCase()}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'Sem: ${material[index]['sem'].toUpperCase()}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {});
                        localDbConnect.deleteMt(material[index]['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Material removed successfully'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline,
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
    );
  }
}
