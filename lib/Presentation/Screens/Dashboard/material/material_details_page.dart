import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/Data/LocalDbConnect.dart';
import 'package:mbm_elearning/Data/Repository/delete_material_repo.dart';
import 'package:mbm_elearning/Data/Repository/post_material_repo.dart';
import 'package:mbm_elearning/Data/Repository/update_material_repo.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/dashboard.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/material/AddMaterial.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialDetailsPage extends StatefulWidget {
  const MaterialDetailsPage(
      {Key? key,
      required this.material,
      required this.isMe,
      required this.ismeSuperAdmin})
      : super(key: key);
  final Map material;
  final bool isMe;
  final bool ismeSuperAdmin;

  @override
  State<MaterialDetailsPage> createState() => _MaterialDetailsPageState();
}

class _MaterialDetailsPageState extends State<MaterialDetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  ScrapTableProvider? scrapTableProvider;
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Material Details");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    showTutorial();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
        widget.material['time'] is String
            ? int.parse(widget.material['time'])
            : widget.material['time'] * 1000);
    scrapTableProvider = Provider.of<ScrapTableProvider>(
      context,
    );
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: rPrimaryLiteColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      typeIcon[widget.material['mttype']],
                      color: rPrimaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.material['mttype'],
                      style: const TextStyle(
                        fontSize: 15,
                        color: rPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                launch(widget.material['mturl']);
              },
              child: Text(
                widget.material['mtname'],
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.ismeSuperAdmin)
                  if (widget.isMe)
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => AddDataToApiBloc(
                                PostMaterialRepo(),
                              ),
                              child: AddMaterialPage(
                                purpose: AddMaterialPagePurpose.update,
                                materialData: widget.material,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                if (widget.isMe)
                  IconButton(
                    onPressed: () async {
                      bool status = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Material'),
                          content: const Text(
                              'Are you sure you want to delete this material?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please wait material deleting...'),
                                  ),
                                );
                                await DeleteMaterialRepo.post(
                                    widget.material['mtid'],
                                    scrapTableProvider!);
                                if (widget.ismeSuperAdmin) {
                                  Navigator.pop(context, true);
                                } else {
                                  int i = 0;
                                  Navigator.popUntil(
                                      context, (route) => i++ == 3);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Material deleted successfully'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                      if (status) {
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                IconButton(
                  key: openInBrowserKey,
                  onPressed: () {
                    launch(widget.material['mturl']);
                  },
                  icon: const Icon(Icons.open_in_browser),
                ),
                if (!kIsWeb)
                  if (!widget.ismeSuperAdmin)
                    IconButton(
                      key: addBookMarkKey,
                      onPressed: () {
                        localDbConnect.addBookMarkMt(
                          BookMarkMt(
                            title: widget.material['mtname'],
                            url: widget.material['mturl'],
                            subject: widget.material['mtsub'],
                            type: widget.material['mttype'],
                            sem: widget.material['mtsem'],
                            branch: widget.material['branch'],
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Material add to bookmark',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.bookmark_border_outlined,
                        size: 25,
                      ),
                    ),
                if (widget.isMe)
                  widget.ismeSuperAdmin
                      ? IconButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please wait material updating...'),
                              ),
                            );
                            var output = await UpdateMaterialRepo.post(
                                widget.material['mtid'],
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                'true',
                                '',
                                scrapTableProvider!);
                            if (output == 'SUCCESS') {
                              Future.delayed(const Duration(milliseconds: 300), () {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Material updated successfully'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                Navigator.pop(context, true);
                              });
                            }
                          },
                          icon: const Icon(Icons.done),
                        )
                      : Tooltip(
                          message: widget.material['approve']
                                      .toString()
                                      .toLowerCase() ==
                                  'true'
                              ? "Material is live to everyone"
                              : "Material is pending for approval",
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: widget.material['approve']
                                        .toString()
                                        .toLowerCase() ==
                                    'true'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Subject: ${widget.material['mtsub']}",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Row(children: [
                  const Icon(
                    Icons.timer,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
                const SizedBox(width: 5),
                Row(children: [
                  const Icon(
                    Icons.school,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.material['mtsem'],
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
                const SizedBox(width: 5),
                Row(children: [
                  const Icon(
                    Icons.margin,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    " ${allBranchSemsData.contains(widget.material['mtsem']) ? "All" : widget.material['branch']}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.material['desc'] != '')
              Text(
                widget.material['desc'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            if (widget.material['uploaded_by_user'] != "N/A")
              ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: rPrimaryLiteColor,
                  child: Text(
                    widget.material['uploaded_by_user'].substring(0, 1) ?? 'U',
                    style: const TextStyle(
                      fontSize: 25,
                      color: rTextColor,
                    ),
                  ),
                ),
                title: Text(
                  '${widget.material['uploaded_by_user'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${widget.material['uploaded_by_user_uid'] ?? 'N/A'}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey addBookMarkKey = GlobalKey();
  GlobalKey openInBrowserKey = GlobalKey();

  void showTutorial() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool(SP.materialDetailsPageTutorial) == null) {
      initTargets();
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: rPrimaryDarkLiteColor,
          textSkip: "SKIP",
          paddingFocus: 10,
          opacityShadow: 0.8, onSkip: () {
        targets.clear();
        pref.setBool(SP.materialDetailsPageTutorial, true);
      }, onFinish: () {
        pref.setBool(SP.materialDetailsPageTutorial, true);
      })
        ..show();
    }
  }

  void initTargets() {
    targets.clear();
    targets.add(targetFocus("Add this material to bookmark", Icons.bookmark,
        addBookMarkKey, "bookmark"));
    targets.add(targetFocus("Click here to open this material in browser",
        Icons.open_in_browser, openInBrowserKey, "browser"));
  }
}
