import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/material_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/material_data_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int skip = 0;
  int limit = 15;
  bool showMt = false;
  late List completeMaterial;
  final TextEditingController queryController = TextEditingController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    completeMaterial = [];
    setCurrentScreenInGoogleAnalytics('search Page');
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
            queryController.text,
            '',
            'true',
            false,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    queryController.text = '';
    itemPositionsListener.itemPositions.removeListener(() {});
    if (completeMaterial.isNotEmpty) {
      completeMaterial.clear();
    }
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
                autofocus: true,
                controller: queryController,
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      completeMaterial.clear();
                    });
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    skip = 0;
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
                        true,
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
                        child: Text('No Data'),
                      )
                    : ScrollablePositionedList.builder(
                        itemPositionsListener: itemPositionsListener,
                        itemCount: completeMaterial.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MaterialListTile(
                              materialData: completeMaterial[index]);
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
            } else if (state is GetMaterialApiNotCall) {
              return Center(
                child: Text("Search anything in any sem and any branch"),
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
