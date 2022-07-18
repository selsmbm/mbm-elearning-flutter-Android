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
import 'package:mbm_elearning/Presentation/Widgets/material_data_list_tile.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
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

class _MaterialsPageState extends State<MaterialsPage> {
  @override
  void initState() {
    super.initState();
    sem = widget.sem;
    if (allBranchSemsData.contains(sem)) {
      branch = '';
    } else {
      branch = widget.branch;
    }
    setCurrentScreenInGoogleAnalytics('material Page');
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
              children: [
                for (var t in mttypes)
                  MtCard(
                    title: t,
                  )
              ],
            ),
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
  ScrapTableProvider? scrapTableProvider;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
      if (!scrapTableProvider!.checkIsNotEmpty()) {
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
              scrapTableProvider!,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    if (material.isNotEmpty) {
      material.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
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
        scrapTableProvider!,
      ),
    );
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
                      return MaterialListTile(
                        materialData: material[index],
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
