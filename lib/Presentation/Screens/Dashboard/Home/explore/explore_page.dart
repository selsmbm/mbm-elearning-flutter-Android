import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/explore/explore_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ScrapTableProvider _scrapTableProvider;

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
    return ModalProgressHUD(
      inAsyncCall: _scrapTableProvider.isGettingExploreData,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Explore'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.arrow_circle_up),
        // ),
        body: RefreshIndicator(
          onRefresh: () => _scrapTableProvider.updateScrapExplore(),
          child: ListView.builder(
            itemCount: _scrapTableProvider.explores.length,
            itemBuilder: (context, index) {
              ExploreModel explore = _scrapTableProvider.explores[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExploreDetailsPage(explore: explore, exploreId: explore.id!);
                      },
                    ),
                  );
                },
                leading: ImageCus(image: explore.image),
                title: Text(explore.title ?? "N/A"),
                subtitle: explore.tagline != null ? Text(explore.tagline!) : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
