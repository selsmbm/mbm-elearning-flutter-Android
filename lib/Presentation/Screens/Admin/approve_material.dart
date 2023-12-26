import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Widgets/material_data_list_tile.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ApproveMaterialPage extends StatefulWidget {
  const ApproveMaterialPage({super.key});
  @override
  _ApproveMaterialPageState createState() => _ApproveMaterialPageState();
}

class _ApproveMaterialPageState extends State<ApproveMaterialPage> {
  int skip = 0;
  int limit = 15;
  bool showMt = false;
  late List completeMaterial;
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  ScrapTableProvider? scrapTableProvider;

  @override
  void initState() {
    super.initState();
    completeMaterial = [];
    setCurrentScreenInGoogleAnalytics('approve material Page');
  }

  @override
  void didChangeDependencies() {
    scrapTableProvider = Provider.of<ScrapTableProvider>(
      context,
    );
    BlocProvider.of<GetMaterialApiBloc>(context).add(
      FetchGetMaterialApi(
        '',
        '',
        null,
        null,
        '',
        '',
        '',
        'false',
        true,
        scrapTableProvider!,
        getDataFromLiveSheet: true,
      ),
    );
    super.didChangeDependencies();
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Unapproved Material'),
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
                          'Nothing here',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ScrollablePositionedList.builder(
                        itemPositionsListener: itemPositionsListener,
                        itemCount: completeMaterial.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MaterialListTile(
                            materialData: completeMaterial[index],
                            isMe: true,
                            ismeSuperAdmin: true,
                          );
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
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
