import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mbm_elearning/Data/Repository/add_event_repo.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';

class AddNewEventPage extends StatefulWidget {
  final int? orgId;
  const AddNewEventPage({Key? key, this.orgId}) : super(key: key);
  @override
  State<AddNewEventPage> createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider _scrapTableProvider;
  String? title;
  String? url;
  String? startTime;
  String? endTime;
  String? desc;
  String? org;
  String? orgtagline;
  String? orgid;
  String? image;
  File? file;
  final TextEditingController startTimeController =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController endTimeController =
      TextEditingController(text: DateTime.now().toString());
  bool showProgress = false;
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Add New Event");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    ExploreModel? selectedExplore;
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    if (widget.orgId != null) {
      selectedExplore = _scrapTableProvider.explores
          .firstWhere((element) => element.id == widget.orgId);
    }
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add new explore'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  if (title != null && desc != null && orgid != null) {
                    setState(() {
                      showProgress = true;
                    });
                    endTime = (DateTime.parse(endTimeController.text)
                                .millisecondsSinceEpoch /
                            1000)
                        .toStringAsFixed(0);
                    startTime = (DateTime.parse(startTimeController.text)
                                .millisecondsSinceEpoch /
                            1000)
                        .toStringAsFixed(0);
                    var outputData = await AddNewEventRepo.post(
                      {
                        "name": title,
                        "url": url ?? '',
                        "startTime": startTime ?? '',
                        "endTime": endTime ?? '',
                        "desc": desc ?? '',
                        "adminOrg": jsonEncode({
                          "name": org,
                          "id": orgid,
                          "image": image ?? '',
                          "tagline": orgtagline ?? ''
                        }),
                        "adminOrgId": orgid,
                      },
                      file,
                      _scrapTableProvider,
                      context,
                    );
                    setState(() {
                      showProgress = false;
                    });
                    if (outputData != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Event added Scuccessfilly.")));
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: const Text('Please fill all required fields'),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var selectFile = (await FilePicker.platform.pickFiles(
                        type: FileType.image,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        backgroundColor: rPrimaryLiteColor,
                        radius: 50,
                        child: file != null
                            ? Image.file(
                                file!,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'What is the name of event? *',
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Website (optional)',
                    ),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    controller: startTimeController,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                    dateLabelText: 'Start date *',
                    timeLabelText: "Start time *",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    controller: endTimeController,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                    dateLabelText: 'End date *',
                    timeLabelText: "End time *",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description *',
                    ),
                    maxLines: 2,
                    onChanged: (value) {
                      desc = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch<ExploreModel>(
                    popupProps: const PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Search explore',
                        ),
                      ),
                    ),
                    enabled: selectedExplore == null,
                    selectedItem: selectedExplore,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select a explore *',
                    )),
                    items: _scrapTableProvider.explores.toList(),
                    itemAsString: (ExploreModel u) => u.title!,
                    onChanged: (ExploreModel? data) {
                      if (data != null) {
                        org = data.title;
                        orgid = data.id.toString();
                        image = data.image ?? '';
                        orgtagline = data.tagline;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
