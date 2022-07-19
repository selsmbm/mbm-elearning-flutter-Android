import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbm_elearning/Data/Repository/GDrive/upload_to_drive.dart';
import 'package:mbm_elearning/Data/Repository/update_material_repo.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mbm_elearning/BLoC/AddDataToApi/add_data_to_api_bloc.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/RoundedInputField.dart';
import 'package:mbm_elearning/Presentation/Screens/Auth/Components/TextFielsContainer.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class AddMaterialPage extends StatefulWidget {
  final AddMaterialPagePurpose purpose;
  final Map<dynamic, dynamic>? materialData;
  const AddMaterialPage(
      {Key? key, this.purpose = AddMaterialPagePurpose.add, this.materialData})
      : super(key: key);
  @override
  _AddMaterialPageState createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  late ScrapTableProvider scrapTableProvider;
  TextEditingController materialName = TextEditingController();
  TextEditingController materialDesc = TextEditingController();
  TextEditingController materialUrl = TextEditingController();
  TextEditingController materialSubject = TextEditingController();
  String? materialBranch;
  String? materialSem;
  String? materialType;
  File? file;
  bool showProgress = false;
  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics('Add material Page');
  }

  @override
  void didChangeDependencies() {
    if (widget.purpose == AddMaterialPagePurpose.update) {
      materialType = widget.materialData!['mttype'];
      materialName.text = widget.materialData!['mtname'];
      materialDesc.text = widget.materialData!['desc'];
      materialUrl.text = widget.materialData!['mturl'];
      materialSubject.text = widget.materialData!['mtsub'];
      materialBranch = widget.materialData!['branch'];
      materialSem = widget.materialData!['mtsem'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    scrapTableProvider = Provider.of<ScrapTableProvider>(
      ctx,
    );
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.purpose == AddMaterialPagePurpose.update
                ? "Update Material"
                : 'Add Material',
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
                scrapTableProvider.updateScrapMaterial();
                ScaffoldMessenger.of(ctx).showSnackBar(
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
                          controller: materialName,
                          hintText: 'Material Name',
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        RoundedInputField(
                          hintText: 'Description',
                          controller: materialDesc,
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        RoundedInputField(
                          hintText: 'Subject',
                          controller: materialSubject,
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
                        if (materialSem != null &&
                            !allBranchSemsData.contains(materialSem))
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
                          height: 9,
                        ),
                        if (widget.purpose != AddMaterialPagePurpose.update)
                          InkWell(
                            onTap: () async {
                              var selectFile =
                                  (await FilePicker.platform.pickFiles(
                                type: FileType.any,
                                allowMultiple: false,
                                onFileLoading: (FilePickerStatus status) =>
                                    print(status),
                              ))
                                      ?.files
                                      .first;
                              if (selectFile != null) {
                                setState(() {
                                  file = File(selectFile.path!);
                                });
                              }
                            },
                            child: TextFieldContainer(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.attach_file),
                                  Text(
                                    file != null
                                        ? p.basename(file!.path)
                                        : "Choose a material",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (widget.purpose != AddMaterialPagePurpose.update)
                          if (file == null) Text("AND"),
                        if (file == null)
                          RoundedInputField(
                            hintText: 'Material url',
                            controller: materialUrl,
                          ),
                        const SizedBox(
                          height: 14,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (materialName.text != '' &&
                                materialSubject.text != '' &&
                                materialSem != '' &&
                                materialType != '') {
                              if (!allBranchSemsData.contains(materialSem)) {
                                if (materialBranch != '') {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select branch'),
                                    ),
                                  );
                                  return;
                                }
                              }
                              if (widget.purpose ==
                                  AddMaterialPagePurpose.update) {
                                setState(() {
                                  showProgress = true;
                                });
                                var output = await UpdateMaterialRepo.post(
                                    widget.materialData!['mtid'],
                                    materialName.text,
                                    materialDesc.text,
                                    materialType,
                                    materialBranch,
                                    materialSem,
                                    materialUrl.text,
                                    '',
                                    materialSubject.text,
                                    scrapTableProvider);
                                if (output == 'SUCCESS') {
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Material updated successfully'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    int i = 0;
                                    Navigator.popUntil(
                                        ctx, (route) => i++ == 3);
                                  });
                                }
                              } else {
                                if (file == null && materialUrl == null) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please add a material or url'),
                                    ),
                                  );
                                  return;
                                }
                                BlocProvider.of<AddDataToApiBloc>(context).add(
                                  FetchAddDataToApi(
                                    materialName.text,
                                    materialDesc.text,
                                    materialType,
                                    materialBranch,
                                    materialSem,
                                    materialUrl.text,
                                    'false',
                                    materialSubject.text,
                                    file,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(ctx).showSnackBar(
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
                              color: rPrimaryColor,
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
