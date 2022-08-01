import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/send_notification.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';

class SendNotificationToAllPage extends StatefulWidget {
  const SendNotificationToAllPage({Key? key}) : super(key: key);
  @override
  State<SendNotificationToAllPage> createState() =>
      _SendNotificationToAllPageState();
}

class _SendNotificationToAllPageState extends State<SendNotificationToAllPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? title;
  String? desc;
  String? url;
  String? image;
  bool showProgress = false;
  @override
  void initState() {
    setCurrentScreenInGoogleAnalytics("Send Notification To All");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send notification to all'),
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
                  if (title != null && desc != null) {
                    setState(() {
                      showProgress = true;
                    });
                    FirebaseNotiSender.send(
                      topic: mbmEleFcmChannel,
                      title: title,
                      desc: desc,
                      clickActionPage: "launchUrl",
                      url: url,
                      bigImage: image,
                    );
                    setState(() {
                      showProgress = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Notification send Scuccessfilly.")));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
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
                      labelText: 'What is the title of the notification? *',
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
                      labelText: 'Description *',
                    ),
                    onChanged: (value) {
                      desc = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Url (optional)',
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
                      labelText:
                          'Image url {Don\'t use drive image directly} (optional)',
                    ),
                    onChanged: (value) {
                      image = value;
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
