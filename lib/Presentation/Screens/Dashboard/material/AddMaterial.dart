import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/RoundedInputField.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/TextFielsContainer.dart';
import 'package:mbm_elearning/Presentation/Screens/Dashboard/Home/Home.dart';
import 'package:uuid/uuid.dart';

class AddMaterialPage extends StatefulWidget {
  @override
  _AddMaterialPageState createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  String? materialType;
  String? materialName;
  String? materialDesc;
  String? materialUrl;
  String? materialSubject;
  String? materialBranch;
  String? materialSem;
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
          centerTitle: true,
          title: const Text(
            'Add Material',
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<AddDataToApiBloc, AddDataToApiState>(
            listener: (context, state) {
              if (state is AddDataToApiIsFailed) {
                setState(() {
                  showProgress = false;
                });
              } else if (state is AddDataToApiIsLoading) {
                setState(() {
                  showProgress = true;
                });
              } else if (state is AddDataToApiIsSuccess) {
                setState(() {
                  showProgress = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully added material.'),
                  ),
                );
              } else if (state is SignupGetOtpApiYetIsNotCall) {}
            },
            builder: (context, state) {
              return SingleChildScrollView(
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
                          hintText: 'Material Name',
                          onChanged: (v) {
                            materialName = v;
                          },
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        RoundedInputField(
                          hintText: 'Description',
                          onChanged: (v) {
                            materialDesc = v;
                          },
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        RoundedInputField(
                          hintText: 'Subject',
                          onChanged: (v) {
                            materialSubject = v;
                          },
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        RoundedInputField(
                          hintText: 'Material url',
                          onChanged: (v) {
                            materialUrl = v;
                          },
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Material Type'),
                            value: materialType,
                            onChanged: (value) {
                              setState(() {
                                materialType = value.toString();
                              });
                            },
                            items: mttypes
                                .map((subject) => DropdownMenuItem(
                                    value: subject, child: Text(subject)))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Material Sem'),
                            value: materialSem,
                            onChanged: (value) {
                              setState(() {
                                materialSem = value.toString();
                              });
                            },
                            items: semsData
                                .map((subject) => DropdownMenuItem(
                                    value: subject, child: Text("$subject")))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Material Branch'),
                            value: materialBranch,
                            onChanged: (value) {
                              setState(() {
                                materialBranch = value.toString();
                              });
                            },
                            items: branches
                                .map((subject) => DropdownMenuItem(
                                    value: subject, child: Text("$subject")))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        TextButton(
                          onPressed: () {
                            if (materialUrl != null) {
                              BlocProvider.of<AddDataToApiBloc>(context).add(
                                FetchAddDataToApi(
                                  materialName,
                                  materialDesc,
                                  materialType,
                                  materialBranch,
                                  materialSem,
                                  materialUrl,
                                  'false',
                                  materialSubject,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all details'),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
