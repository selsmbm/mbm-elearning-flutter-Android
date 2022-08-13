import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Widgets/material_data_list_tile.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ScrapTableProvider? scrapTableProvider;

  @override
  void initState() {
    super.initState();
    completeMaterial = [];
    setCurrentScreenInGoogleAnalytics('search Page');
    itemPositionsListener.itemPositions.addListener(() {
      if (scrapTableProvider != null) {
        if (!scrapTableProvider!.checkIsNotEmpty()) {
          if (itemPositionsListener.itemPositions.value.last.index ==
              skip + 14) {
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
                scrapTableProvider!,
              ),
            );
          }
        }
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
  void didChangeDependencies() {
    scrapTableProvider = Provider.of<ScrapTableProvider>(
      context,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'addMaterialPage');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add material'),
      ),
      bottomNavigationBar: scrapTableProvider!.banner3 != null &&
              scrapTableProvider!.banner2!['status'] == true
          ? InkWell(
              onTap: () {
                launch(scrapTableProvider!.banner2!['url']);
              },
              child: Image.network(
                scrapTableProvider!.banner2!['image'],
              ),
            )
          : null,
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
                        scrapTableProvider!,
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
                color: Colors.black,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetMaterialApiIsFailed) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else if (state is GetMaterialApiNotCall) {
              return const Center(
                child: Text("Search anything in any sem and any branch"),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
