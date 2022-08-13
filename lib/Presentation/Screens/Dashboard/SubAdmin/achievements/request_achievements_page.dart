import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/request_acievement_repo.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';

class RequestAchievementPage extends StatefulWidget {
  const RequestAchievementPage({Key? key}) : super(key: key);

  @override
  State<RequestAchievementPage> createState() => _RequestAchievementPageState();
}

class _RequestAchievementPageState extends State<RequestAchievementPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider _scrapTableProvider;
  String? title;
  String? mobile;
  String? position;
  String? org;
  String? orgid;
  bool showProgress = false;
  @override
  Widget build(BuildContext context) {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Achievement'),
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
                  if (title != null &&
                      mobile != null &&
                      orgid != null &&
                      position != null) {
                    setState(() {
                      showProgress = true;
                    });
                    var outputData = await RequestAchievementRepo.post(
                      title,
                      user!.uid,
                      user!.email,
                      mobile,
                      position,
                      org,
                      orgid,
                    );
                    print(outputData);
                    setState(() {
                      showProgress = false;
                    });
                    if (outputData != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Requested successfully.")));
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name *',
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
                      labelText: 'Mobile No *',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      mobile = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Your position (like: Member or lead)*',
                    ),
                    maxLines: 1,
                    onChanged: (value) {
                      position = value;
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
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select a explore *',
                    )),
                    items: _scrapTableProvider.explores.toSet().toList(),
                    itemAsString: (ExploreModel u) => u.title!,
                    onChanged: (ExploreModel? data) {
                      if (data != null) {
                        org = data.title;
                        orgid = data.id.toString();
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
