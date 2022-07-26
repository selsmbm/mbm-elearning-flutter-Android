import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(admin.position!),
                if (admin.branch != null && admin.branch != "")
                  Text(admin.branch!),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (admin.year != null && admin.year != "")
                  Text(
                    "Batch: ${admin.year}",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (admin.email != null && admin.email != "")
                      InkWell(
                        child: Icon(
                          Icons.email,
                          color: rPrimaryMaterialColor,
                        ),
                        onTap: () {
                          launch("mailto:${admin.email}");
                        },
                      ),
                    const SizedBox(width: 10),
                    if (admin.linkedin != null && admin.linkedin != "")
                      InkWell(
                        onTap: () {
                          launch(admin.linkedin!);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/linkedin.svg',
                          height: 20,
                          width: 20,
                          color: rPrimaryMaterialColor,
                        ),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
