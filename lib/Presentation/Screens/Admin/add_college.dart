import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/RoundedInputField.dart';

class AddCollegePage extends StatefulWidget {
  const AddCollegePage({Key? key}) : super(key: key);

  @override
  _AddCollegePageState createState() => _AddCollegePageState();
}

class _AddCollegePageState extends State<AddCollegePage> {
  String? collegeName;
  String? sheetApi;
  String? website;
  String? logo;
  String? syllabus;
  String? academic;
  String? branches;
  String? sems;

  bool showProgress = false;
  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Add material Page');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: rPrimaryColor,
          centerTitle: true,
          title: const Text(
            'Add College',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'Righteous',
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    RoundedInputField(
                      hintText: 'College Full Name*',
                      onChanged: (v) {
                        collegeName = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'Sheet api url*',
                      onChanged: (v) {
                        sheetApi = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'College website url*',
                      onChanged: (v) {
                        website = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'College Logo url*',
                      onChanged: (v) {
                        logo = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'Syllabus url',
                      onChanged: (v) {
                        syllabus = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'Academic Colender url',
                      onChanged: (v) {
                        academic = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'Branches (commaseperated)*',
                      maxLines: 4,
                      onChanged: (v) {
                        branches = v;
                      },
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    RoundedInputField(
                      hintText: 'Sems (commaseperated)*',
                      maxLines: 4,
                      onChanged: (v) {
                        sems = v;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextButton(
                      onPressed: () {
                        if (branches != null) {
                          FirebaseFirestore.instance
                              .collection('colleges')
                              .add({
                            'collegeName': collegeName ?? '',
                            'sheetApi': sheetApi ?? '',
                            'website': website ?? '',
                            'syllabus': syllabus ?? '',
                            'academic': academic ?? '',
                            'branches': branches ?? '',
                            'sems': sems ?? '',
                            'logo': logo ?? '',
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('College added successfully'),
                              ),
                            );
                            Navigator.pop(context);
                          }).catchError((error) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error ${error.toString()}'),
                                    ),
                                  ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000429),
                              blurRadius: 20.27,
                              offset: Offset(-0.18, 2),
                            ),
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff000b75), Color(0xff001cff)],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
