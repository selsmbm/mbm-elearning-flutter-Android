import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/model/teachers_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherDetails extends StatefulWidget {
  const TeacherDetails({Key? key, this.teacherData}) : super(key: key);
  final TeachersModel? teacherData;
  @override
  State<TeacherDetails> createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  late TeachersModel teacher;

  @override
  void initState() {
    teacher = widget.teacherData!;
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teacher.name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (teacher.post != null &&
                                  teacher.post!.isNotEmpty)
                                Text(
                                  teacher.post!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              if (teacher.department != null &&
                                  teacher.department!.isNotEmpty)
                                Text(
                                  teacher.department!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              if (teacher.dOB != null && teacher.dOB != '')
                                Row(
                                  children: [
                                    Icon(Icons.cake_outlined),
                                    const SizedBox(width: 5),
                                    Text(
                                      teacher.dOB!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              if (teacher.dOB != null && teacher.dOB != '')
                                const SizedBox(height: 7),
                              Row(
                                children: [
                                  const SizedBox(height: 10),
                                  if (teacher.email != null &&
                                      teacher.email != '')
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          launch('mailto:${teacher.email}');
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                teacher.email!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  if (teacher.mobileNo != null &&
                                      teacher.mobileNo != '')
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          launch('tel:${teacher.mobileNo}');
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone_outlined,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              teacher.mobileNo!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              if (teacher.uG != null && teacher.uG != '')
                                const SizedBox(height: 10),
                              if (teacher.uG != null && teacher.uG != '')
                                Row(
                                  children: [
                                    degreeIcon("UG"),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        teacher.uG!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (teacher.pG != null && teacher.pG != '')
                                const SizedBox(height: 10),
                              if (teacher.pG != null && teacher.pG != '')
                                Row(
                                  children: [
                                    degreeIcon("PG"),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        teacher.pG!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (teacher.phd != null && teacher.phd != '')
                                const SizedBox(height: 10),
                              if (teacher.phd != null && teacher.phd != '')
                                Row(
                                  children: [
                                    degreeIcon("PhD"),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        teacher.phd!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
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
              child: CircleAvatar(
                radius: 54,
                backgroundColor: rPrimaryMaterialColorLite,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "$driveImageShowUrl${teacher.image != null && teacher.image != "" ? teacher.image : defaultUserDriveImageShowUrl}",
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

  Container degreeIcon(String degree) {
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
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
