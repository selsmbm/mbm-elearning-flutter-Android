import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ScrapTableProvider _scrapTableProvider;
  late List<ExploreModel> explores;
  List<ExploreModel>? filterExplores;

  @override
  void didChangeDependencies() {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Explore Page');
  }

  @override
  Widget build(BuildContext context) {
    explores = _scrapTableProvider.explores.toSet().toList();
    return ModalProgressHUD(
      inAsyncCall: _scrapTableProvider.isGettingExploreData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Explore'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showModalBottomSheet(
        //       context: context,
        //       builder: (context) => Container(
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //               'Select Category',
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Wrap(
        //               children: [
        //                 for (String type in exploreType)
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(
        //                       horizontal: 5,
        //                     ),
        //                     child: ElevatedButton(
        //                       onPressed: () {
        //                         setState(() {
        //                           filterExplores = _scrapTableProvider.explores
        //                               .where((element) => element.type == type)
        //                               .toList();
        //                           Navigator.pop(context);
        //                         });
        //                       },
        //                       child: Text(
        //                         type,
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        //   child: const Icon(Icons.filter_list),
        // ),
        body: RefreshIndicator(
          onRefresh: () => _scrapTableProvider.updateScrapExplore(),
          child: ListView.builder(
            itemCount: filterExplores != null
                ? filterExplores!.length
                : explores.length,
            itemBuilder: (context, index) {
              ExploreModel explore = filterExplores != null
                  ? filterExplores![index]
                  : explores[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExploreDetailsPage(
                            explore: explore, exploreId: explore.id!);
                      },
                    ),
                  );
                },
                leading: GestureDetector(
                    onTap: () {
                      bigImageShower(
                        context,
                        "$driveImageShowUrl${explore.image != null && explore.image != '' ? explore.image : defaultDriveImageShowUrl}",
                      );
                    },
                    child: ImageCus(image: explore.image)),
                title: Text(explore.title ?? "N/A"),
                subtitle:
                    explore.tagline != null ? Text(explore.tagline!) : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
