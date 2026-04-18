import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Widgets/empty_state_view.dart';
import 'package:mbm_elearning/Presentation/Widgets/material_data_list_tile.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

String? sem;
String? branch;

class MaterialsPage extends StatefulWidget {
  final String? sem;
  final String? branch;
  const MaterialsPage({super.key, this.sem, this.branch});
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
    setCurrentScreenInGoogleAnalytics('Sem:$sem branch:$branch material Page');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 5);
    var tabTextStyle = TextStyle(
      color: Theme.of(context).primaryColor == rConditionColor
          ? rTextColor
          : Colors.white,
      fontSize: 12,
    );
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'addMaterialPage');
          },
          icon: const Icon(Icons.add),
          label: const Text('Add material'),
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
              labelColor: rPrimaryMaterialColor,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: rPrimaryMaterialColor, width: 3.0),
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
    super.key,
    required this.title,
  });

  @override
  _MtCardState createState() => _MtCardState();
}

class _MtCardState extends State<MtCard> {
  int skip = 0;
  int limit = 15;
  bool showMt = false;
  List material = [];
  bool _didLoadInitialData = false;
  late final GetMaterialApiBloc _materialBloc;
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  ScrapTableProvider? scrapTableProvider;

  @override
  void initState() {
    super.initState();
    _materialBloc = GetMaterialApiBloc(GetMaterialRepo());
    itemPositionsListener.itemPositions.addListener(() {
      if (scrapTableProvider == null ||
          scrapTableProvider!.checkIsNotEmpty() ||
          itemPositionsListener.itemPositions.value.isEmpty ||
          material.isEmpty) {
        return;
      }

      if (itemPositionsListener.itemPositions.value.last.index >=
          material.length - 1) {
        skip = skip + limit;
        _materialBloc.add(
          FetchGetMaterialApi(
            sem ?? '',
            branch ?? '',
            skip,
            limit,
            widget.title,
            '',
            '',
            'true',
            false,
            scrapTableProvider!,
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrapTableProvider ??= Provider.of<ScrapTableProvider>(context);
    if (_didLoadInitialData) {
      return;
    }

    _materialBloc.add(
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
    _didLoadInitialData = true;
  }

  @override
  void dispose() {
    if (material.isNotEmpty) {
      material.clear();
    }
    _materialBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return BlocBuilder<GetMaterialApiBloc, GetMaterialApiState>(
      bloc: _materialBloc,
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
                ? EmptyStateView(
                    icon: _getMaterialEmptyIcon(widget.title),
                    title: 'No ${widget.title} available',
                    message:
                        'Materials for this tab will appear here when data is available.',
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      },
    );
  }

  IconData _getMaterialEmptyIcon(String type) {
    switch (type) {
      case 'notes':
        return Icons.description_outlined;
      case 'paper':
        return Icons.article_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'file':
        return Icons.folder_open_outlined;
      case 'video':
        return Icons.ondemand_video_outlined;
      default:
        return Icons.inbox_outlined;
    }
  }
}
