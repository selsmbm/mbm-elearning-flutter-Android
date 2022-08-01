import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class YourMaterialPage extends StatefulWidget {
  const YourMaterialPage({Key? key}) : super(key: key);
  @override
  _YourMaterialPageState createState() => _YourMaterialPageState();
}

class _YourMaterialPageState extends State<YourMaterialPage> {
  User? user = FirebaseAuth.instance.currentUser;
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
    setCurrentScreenInGoogleAnalytics('your uploaded material Page');
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
        user!.uid,
        '',
        true,
        scrapTableProvider!,
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
    return ModalProgressHUD(
      inAsyncCall: scrapTableProvider!.isGettingMaterialData,
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
          title: const Text('Your Material'),
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
                            'Nothing here\nUpload some material',
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
      ),
    );
  }
}
