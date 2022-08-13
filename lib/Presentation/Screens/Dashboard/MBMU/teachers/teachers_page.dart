import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/get_teachers_data.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/teachers_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Constants/utills.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/MBMU/teachers/teacher_details_page.dart';
import 'package:mbm_elearning/Presentation/Widgets/image_cus.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({Key? key}) : super(key: key);
  @override
  _TeachersPageState createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  late List<TeachersModel> outPutData;
  List<TeachersModel> filteredData = [];
  bool showProgress = false;
  bool showSearchBar = false;

  @override
  void initState() {
    getTeachers();
    setCurrentScreenInGoogleAnalytics("Teachers");
    super.initState();
  }

  getTeachers() {
    setState(() {
      showProgress = true;
    });
    GetTeachersDataRepo.get().then((value) {
      setState(() {
        outPutData = value;
        showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: showSearchBar
            ? Container(
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
                      maxLines: 1,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            filteredData.clear();
                          });
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          filteredData.clear();
                          setState(() {
                            filteredData.addAll(outPutData.reversed
                                .toList()
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .contains(RegExp(value.toLowerCase()))));
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    )),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filteredData.clear();
                          showSearchBar = false;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            : const Text(
                'Teachers',
              ),
        actions: [
          if (!showProgress)
            if (!showSearchBar)
              IconButton(
                onPressed: () {
                  setState(() {
                    showSearchBar = true;
                  });
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: showProgress
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    if (filteredData.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return listTile(filteredData[index]);
                          },
                        ),
                      ),
                    if (filteredData.isEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: outPutData.length,
                          itemBuilder: (context, index) {
                            return listTile(outPutData[index]);
                          },
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  listTile(TeachersModel model) {
    return ListTile(
      title: Text(model.name!),
      subtitle: Text(model.department!),
      leading: GestureDetector(
        onTap: () {
          bigImageShower(context,
              "$driveImageShowUrl${model.image != null && model.image != "" ? model.image : defaultUserDriveImageShowUrl}");
        },
        child: UserImageCus(
          image: model.image,
        ),
      ),
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (ctx, a1, a2) => TeacherDetails(
            teacherData: model,
          ),
        );
      },
    );
  }
}
