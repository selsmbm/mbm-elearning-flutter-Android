import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/GetMaterialBloc/get_material_bloc.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/material_details_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';

class MaterialListTile extends StatefulWidget {
  const MaterialListTile({
    Key? key,
    required this.materialData,
    this.isMe = false,
    this.ismeSuperAdmin = false,
  }) : super(key: key);

  final Map<dynamic, dynamic> materialData;
  final bool isMe;
  final bool ismeSuperAdmin;

  @override
  State<MaterialListTile> createState() => _MaterialListTileState();
}

class _MaterialListTileState extends State<MaterialListTile> {
  late ScrapTableProvider scrapTableProvider;

  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(
      context,
    );
    return ListTile(
      onTap: () async {
        bool? status = await showDialog(
          context: context,
          builder: (context) => BlocProvider(
            create: (context) => GetMaterialApiBloc(
              GetMaterialRepo(),
            ),
            child: MaterialDetailsPage(
              material: widget.materialData,
              isMe: widget.isMe,
              ismeSuperAdmin: widget.ismeSuperAdmin,
            ),
          ),
        );
        if (status != null && status) {
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
              scrapTableProvider,
              getDataFromLiveSheet: true,
            ),
          );
        }
      },
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: rPrimaryLiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Icon(
            typeIcon[widget.materialData['mttype']],
            color: rPrimaryColor,
          ),
        ),
      ),
      title: Text(
        widget.materialData['mtname'],
      ),
      subtitle: Text(
        widget.materialData['mtsub'].toUpperCase(),
      ),
    );
  }
}
