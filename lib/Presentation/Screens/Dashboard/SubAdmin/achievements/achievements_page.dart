import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Presentation/Screens/Admin/dashboard.dart';
import 'package:mbm_elearning/Presentation/Widgets/model_progress.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List orgsData = [];
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    var userd = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (mounted) {
      setState(() {
        _isLoading = false;
        orgsData.addAll(userd.data()!['orgs'] ?? []);
      });
    } else {
      _isLoading = false;
      orgsData.addAll(userd.data()!['orgs'] ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Achievements'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'request_achievement_page');
          },
          icon: Icon(Icons.add),
          label: Text('Request achievements'),
        ),
        body: !_isLoading
            ? orgsData.length > 0
                ? ListView.builder(
                    itemCount: orgsData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDashboard(
                                isSuperAdmin: false,
                                orgId: int.parse(orgsData[index]['orgId']),
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.arrow_forward_ios),
                        title: Text(orgsData[index]['orgName']),
                      );
                    },
                  )
                : Center(
                    child: Text("You are not admin of any explore"),
                  )
            : SizedBox(),
      ),
    );
  }
}
