import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/add_new_admin.dart';
import 'package:mbm_elearning/Data/Repository/request_acievement_repo.dart';
import 'package:mbm_elearning/Data/Repository/sheet_scrap.dart';
import 'package:mbm_elearning/Data/model/verification_user_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class VerifiedUsers extends StatefulWidget {
  const VerifiedUsers({Key? key}) : super(key: key);

  @override
  State<VerifiedUsers> createState() => _VerifiedUsersState();
}

class _VerifiedUsersState extends State<VerifiedUsers> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Verified Users'),
        ),
        body: FutureBuilder<List<VerificationUserModel>>(
          future: Scrap.scrapVerificationUsersList(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<VerificationUserModel> data = snapshot.data
                  .where((element) => element.status.toLowerCase() == 'false')
                  .toList();
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  VerificationUserModel model = data[index];
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await RequestAchievementRepo.delete(
                            model.id.toString());
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var out = await AddNewAdmin.post(
                          model.name,
                          model.userId,
                          model.position,
                          model.orgId,
                        );
                        print(out);
                        if (out == "SUCCESS") {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(model.userId)
                              .update({
                            "orgs": FieldValue.arrayUnion([
                              {
                                "orgId": model.orgId,
                                "orgName": model.orgName,
                              }
                            ])
                          });
                          await RequestAchievementRepo.delete(
                              model.id.toString());
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    title: Text(model.name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.email!),
                        Text(model.mobile!),
                        Text("Position : ${model.position}"),
                        Text("Department : ${model.orgName}"),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
