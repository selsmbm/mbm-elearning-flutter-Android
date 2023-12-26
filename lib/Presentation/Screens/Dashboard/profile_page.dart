import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/googleAnalytics.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final bool isItInitialUpdate;
  const ProfilePage({super.key, this.isItInitialUpdate = false});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userInitData;
  bool isNewUser = false;
  bool showProgress = true;
  final User? user = FirebaseAuth.instance.currentUser;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _passoutyearController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setCurrentScreenInGoogleAnalytics("Profile");
    getUserData();
  }

  getUserData() async {
    var userd = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    userInitData = userd.data();
    if (userInitData == null) {
      isNewUser = true;
    }
    Map userData = userInitData ?? {};
    _nameController.text = userData['username'] ?? '';
    _emailController.text = userData['useremail'] ?? '';
    _phoneController.text = userData['mobileNo'] ?? '';
    _registrationController.text = userData['registrationNo'] ?? '';
    _branchController.text = userData['branch'] ?? '';
    _passoutyearController.text =
        (userData['year'] ?? "").length != 4 ? "" : userData['year'];
    _typeController.text = userData['type'] ?? '';
    _rollnoController.text = userData['rollNo'] ?? '';
    if (mounted) {
      setState(() {
        showProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Profile',
          ),
        ),
        bottomNavigationBar: showProgress
            ? null
            : BottomAppBar(
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
                        if (_typeController.text.isNotEmpty ||
                            _phoneController.text.isNotEmpty ||
                            _emailController.text.isNotEmpty ||
                            _nameController.text.isNotEmpty) {
                          if (_typeController.text.contains(student)) {
                            if (_registrationController.text == "" ||
                                _branchController.text == "" ||
                                _passoutyearController.text.length != 4) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Please fill all the details validly'),
                              ));
                              return;
                            }
                          } else if (_typeController.text == alumni) {
                            if (_branchController.text == "" ||
                                _passoutyearController.text.length != 4) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Please fill all the details validly'),
                              ));
                              return;
                            }
                          }
                          setState(() {
                            showProgress = true;
                          });
                          if (isNewUser) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .set({
                              'username': _nameController.text,
                              'useremail': _emailController.text,
                              'mobileNo': _phoneController.text,
                              'registrationNo': _registrationController.text,
                              'branch': _branchController.text,
                              'year': _passoutyearController.text,
                              'type': _typeController.text,
                              'rollNo': _rollnoController.text,
                              "updatedat": DateTime.now(),
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .update({
                              'username': _nameController.text,
                              'useremail': _emailController.text,
                              'mobileNo': _phoneController.text,
                              'registrationNo': _registrationController.text,
                              'branch': _branchController.text,
                              'year': _passoutyearController.text,
                              'type': _typeController.text,
                              'rollNo': _rollnoController.text,
                              "updatedat": DateTime.now(),
                            });
                          }
                          await user!.updateDisplayName(_nameController.text);
                          await user!.updatePhotoURL(_typeController.text);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setBool(SP.initialProfileSaved, true);
                          setState(() {
                            showProgress = false;
                          });
                          if (widget.isItInitialUpdate) {
                            Navigator.pushReplacementNamed(
                                context, 'dashboard');
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Profile updated successfully'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please fill all the details'),
                          ));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.isItInitialUpdate ? 'Submit' : "Update",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
        body: showProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text(
                        "Please provide your original details. Because teachers will be able to see your details.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      DropdownSearch<String>(
                        enabled: _typeController.text == '' || isNewUser,
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Your are a',
                            ),
                          ),
                        ),
                        selectedItem: _typeController.text,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          labelText: 'Your are a *',
                        )),
                        items: userTypes,
                        itemAsString: (String u) => u,
                        onChanged: (String? data) {
                          if (data != null) {
                            setState(() {
                              _typeController.text = data;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your name *',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailController,
                        readOnly: _emailController.text != "",
                        decoration: const InputDecoration(
                          labelText: 'Your email *',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone number *',
                        ),
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value != null && value.length != 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_typeController.text == student)
                        TextFormField(
                          controller: _registrationController,
                          decoration: const InputDecoration(
                            labelText: 'Registration number (Ex. J19U444444) *',
                          ),
                        ),
                      if (_typeController.text == student)
                        const SizedBox(
                          height: 10,
                        ),
                      if (_typeController.text == student)
                        TextFormField(
                          controller: _rollnoController,
                          decoration: const InputDecoration(
                            labelText: 'Roll number (optional)',
                          ),
                        ),
                      if (_typeController.text == student)
                        const SizedBox(
                          height: 10,
                        ),
                      DropdownSearch<String>(
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Branch',
                            ),
                          ),
                        ),
                        selectedItem: _branchController.text,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          labelText: 'Branch *',
                        )),
                        items: branches,
                        itemAsString: (String u) => u,
                        onChanged: (String? data) {
                          if (data != null) {
                            _branchController.text = data;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_typeController.text == student ||
                          _typeController.text == alumni)
                        TextFormField(
                          readOnly: true,
                          controller: _passoutyearController,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Select Year"),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: YearPicker(
                                      firstDate: DateTime(1951, 1),
                                      lastDate: DateTime(
                                          DateTime.now().year + 100, 1),
                                      initialDate: DateTime.now(),
                                      selectedDate: selectedDate,
                                      onChanged: (DateTime dateTime) {
                                        _passoutyearController.text =
                                            dateTime.year.toString();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          decoration: const InputDecoration(
                            labelText: 'Passout year *',
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please select your passout year';
                            } else if (value != null && value.length != 4) {
                              return 'Please select a valid passout year';
                            } else {
                              return null;
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
    );
  }
}
