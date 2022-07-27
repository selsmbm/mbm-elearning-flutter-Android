import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/utilities/sels_admins/sels_admin_details_page.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SELSAdminsPage extends StatefulWidget {
  const SELSAdminsPage({Key? key}) : super(key: key);

  @override
  State<SELSAdminsPage> createState() => _SELSAdminsPageState();
}

class _SELSAdminsPageState extends State<SELSAdminsPage> {
  late ScrapTableProvider scrapTableProvider;
  @override
  Widget build(BuildContext context) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('SELS'),
      ),
      body: ListView.builder(
        itemCount: scrapTableProvider.admins.length,
        itemBuilder: (context, index) {
          AdminsModel admin = scrapTableProvider.admins[index];
          return ListTile(
            onTap: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (ctx, a1, a2) => SELSAdminDetails(
                  admin: admin,
                ),
              );
            },
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: rPrimaryMaterialColorLite,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: NetworkImage(
                    admin.image != null && admin.image != ""
                        ? admin.image!
                        : "$driveImageShowUrl$defaultUserDriveImageShowUrl",
                  ),
                ),
              ),
            ),
            title: Text(admin.name!),
            subtitle: Text(admin.position!),
          );
        },
      ),
    );
  }
}
