import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/admins_model.dart';
import 'package:mbm_elearning/Data/model/teachers_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:url_launcher/url_launcher.dart';

class SELSAdminDetails extends StatefulWidget {
  const SELSAdminDetails({Key? key, this.admin}) : super(key: key);
  final AdminsModel? admin;
  @override
  State<SELSAdminDetails> createState() => _SELSAdminDetailsState();
}

class _SELSAdminDetailsState extends State<SELSAdminDetails> {
  late AdminsModel admin;

  @override
  void initState() {
    admin = widget.admin!;
    setCurrentScreenInGoogleAnalytics("SELS Admin Details");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor ==
                            rPrimaryMaterialColorLite
                        ? Colors.white
                        : rPrimaryDarkLiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      admin.name!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (admin.position != null &&
                                        admin.position!.isNotEmpty)
                                      Text(
                                        admin.position!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    if (admin.branch != null &&
                                        admin.branch!.isNotEmpty)
                                      Text(
                                        admin.branch!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              if (admin.year != null && admin.year != '')
                                const SizedBox(height: 10),
                              if (admin.year != null && admin.year != '')
                                Row(
                                  children: [
                                    yearIcon("BATCH"),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        admin.year!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (admin.email != null && admin.email != "")
                                const SizedBox(height: 10),
                              if (admin.email != null && admin.email != "")
                                InkWell(
                                  onTap: () {
                                    launch("mailto:${admin.email}");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: rPrimaryMaterialColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          admin.email!,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (admin.linkedin != null &&
                                  admin.linkedin != "")
                                const SizedBox(height: 10),
                              if (admin.linkedin != null &&
                                  admin.linkedin != "")
                                InkWell(
                                  onTap: () {
                                    launch(admin.linkedin!);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/linkedin.svg',
                                        height: 25,
                                        width: 25,
                                        color: rPrimaryMaterialColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          admin.linkedin!,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  bigImageShower(
                    context,
                    admin.image != null && admin.image != ""
                        ? admin.image!
                        : "$driveImageShowUrl$defaultUserDriveImageShowUrl",
                  );
                },
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: rPrimaryMaterialColorLite,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: NetworkImage(
                        admin.image != null && admin.image != ""
                            ? admin.image!
                            : "$driveImageShowUrl$defaultUserDriveImageShowUrl",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container yearIcon(String degree) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: rPrimaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          degree,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
