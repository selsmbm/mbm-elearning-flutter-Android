import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mbm_elearning/Data/Repository/post_feed_post.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Data/model/events_model.dart';
import 'package:mbm_elearning/Data/model/explore_model.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Widgets/html_editor.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';
import 'package:provider/provider.dart';

class AddNewFeedPage extends StatefulWidget {
  final int? orgId;
  const AddNewFeedPage({Key? key, this.orgId}) : super(key: key);

  @override
  State<AddNewFeedPage> createState() => _AddNewFeedPageState();
}

class _AddNewFeedPageState extends State<AddNewFeedPage> {
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
  void initState() {
    setCurrentScreenInGoogleAnalytics("Add New Feed");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExploreModel? selectedExplore;
    List<EventsModel> events = [];
    _scrapTableProvider = Provider.of<ScrapTableProvider>(context);
    if (widget.orgId != null) {
      selectedExplore = _scrapTableProvider.explores
          .firstWhere((element) => element.id == widget.orgId);
      events.addAll(_scrapTableProvider.events.where(
          (element) => element.adminOrgIds!.contains(widget.orgId.toString())));
    } else {
      events.addAll(_scrapTableProvider.events);
    }
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add new post'),
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
                  if (title != null) {
                    String? output = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HtmlEditorScreen(
                          showdesc: true,
                        ),
                      ),
                    );
                    if (output != null) {
                      setState(() {
                        showProgress = true;
                      });
                      var outputData = await PostFeedPostRepo.post(
                        {
                          "title": title,
                          "event": event ?? '',
                          "image": image,
                          "org": org ?? '',
                          "url": url ?? '',
                          "orgid": orgid ?? '',
                          "eventid": eventid ?? '',
                          "uploaded_by_user": user!.displayName,
                          "uploaded_by_user_uid": user!.uid,
                          "description": output
                        },
                        _scrapTableProvider,
                      );
                      setState(() {
                        showProgress = false;
                      });
                      if (outputData != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Post added Scuccessfilly.")));
                        Navigator.pop(context);
                      }
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
                    'Next',
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
                      labelText: 'What is the title of your post? *',
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
                      labelText: 'Url {website, form link, etc.} (optional)',
                    ),
                    onChanged: (value) {
                      url = value;
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
                      labelText: 'Select a explore (optional)',
                    )),
                    items: _scrapTableProvider.explores,
                    itemAsString: (ExploreModel u) => u.title!,
                    onChanged: (ExploreModel? data) {
                      if (data != null) {
                        org = data.title;
                        orgid = data.id.toString();
                        image = data.image != null && data.image != ""
                            ? "$driveImageShowUrl${data.image}"
                            : "";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch<EventsModel>(
                    popupProps: const PopupProps.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText: 'Search event',
                        ),
                      ),
                    ),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                      labelText: 'Select a event (optional)',
                    )),
                    items: events,
                    itemAsString: (EventsModel u) => u.title!,
                    onChanged: (EventsModel? data) {
                      if (data != null) {
                        event = data.title;
                        eventid = data.id.toString();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
