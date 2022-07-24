import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddNewExplorePage extends StatefulWidget {
  const AddNewExplorePage({Key? key}) : super(key: key);
  @override
  State<AddNewExplorePage> createState() => _AddNewExplorePageState();
}

class _AddNewExplorePageState extends State<AddNewExplorePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late ScrapTableProvider _scrapTableProvider;
  String? title;
  String? url;
  String? org;
  String? orgid;
  String? event;
  String? eventid;
  String? image;
  bool showProgress = false;
  @override
  Widget build(BuildContext context) {
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
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
                  // if (title != null) {
                  //   String? output = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => HtmlEditorScreen(
                  //         showdesc: true,
                  //       ),
                  //     ),
                  //   );
                  //   if (output != null) {
                  //     setState(() {
                  //       showProgress = true;
                  //     });
                  //     var outputData = await PostFeedPostRepo.post(
                  //       {
                  //         "title": title,
                  //         "event": event ?? '',
                  //         "image": image,
                  //         "org": org ?? '',
                  //         "url": url ?? '',
                  //         "orgid": orgid ?? '',
                  //         "eventid": eventid ?? '',
                  //         "uploaded_by_user": user!.displayName,
                  //         "uploaded_by_user_uid": user!.uid,
                  //         "description": output
                  //       },
                  //       _scrapTableProvider,
                  //     );
                  //     setState(() {
                  //       showProgress = false;
                  //     });
                  //     // if (outputData['status'] == "SUCCESS") {
                  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //         content: Text("Post Uploaded Scuccessfilly.")));
                  //     Navigator.pop(context);
                  //     // }
                  //   }
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: const Text('Please fill all required fields'),
                  //     ),
                  //   );
                  // }
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
                      labelText: 'What is the name of explore? *',
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Tagline (optional)',
                    ),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch<String>(
                    popupProps: const PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Type',
                        ),
                      ),
                    ),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select a type',
                    )),
                    items: [],
                    itemAsString: (String u) => u,
                    onChanged: (String? data) {
                      if (data != null) {}
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
